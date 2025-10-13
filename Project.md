Awesome—here’s the Copier frontend template spec updated to ensure it creates a Dockerfile + Docker Compose and is deployment-ready out of the box (with SPA routing, env injection at runtime, healthcheck, and CI). Everything below is written as files you can drop into your template repo. I’m keeping all filenames and Jinja placeholders consistent so the template renders cleanly.

🧩 Alkeme Template Frontend — Deployment-Ready (Vite + React + TS + Tailwind)
What this template generates

Production build (Vite) and Nginx static serving (with SPA fallback)

Runtime env injection (no rebuild needed to change env)

Dockerfile (multi-stage, tiny final image)

docker-compose.yml (prod-like run; optional backend reference)

.env.example (safe defaults)

Healthcheck + sensible Nginx caching rules

CI (build + test + Docker build) — optional via Copier flag

Cursor Rules capturing Alkeme engineering practices

Scope: frontend only, but docker-compose.yml includes commented stubs to link to a FastAPI backend later.

copier.yml (front-end slice)
# copier.yml
_min_copier_version: "9.2"
_subdirectory: template/frontend
_templates_suffix: .jinja

project_name:
  type: str
  help: "Frontend project name"
  default: "Alkeme Template Frontend"

package_name:
  type: str
  help: "NPM package name (kebab-case)"
  default: "{{ project_name | lower | replace(' ', '-') }}"

owner_org:
  type: str
  help: "Owning org/team"
  default: "Alkeme"

use_azure_auth:
  type: bool
  help: "Include Azure AD (MSAL.js) scaffolding?"
  default: true

use_kanban:
  type: bool
  help: "Include Kanban feature scaffold (dnd-kit)?"
  default: true

use_dashboard:
  type: bool
  help: "Include KPI Dashboard scaffold?"
  default: true

ci_github_actions:
  type: bool
  help: "Add GitHub Actions CI (lint/type/test + docker build)?"
  default: true

# Post-gen init
_tasks:
  - "git init -q"
  - "corepack enable || true"
  - "pnpm i || npm i || yarn"
  - "git add ."
  - "git commit -m 'chore: scaffold {{ package_name }} via Copier'"

Output structure
{{ package_name }}/
├─ Dockerfile
├─ docker-compose.yml
├─ .env.example
├─ docker/
│  ├─ nginx.conf
│  └─ entrypoint.sh
├─ index.html
├─ vite.config.ts
├─ tsconfig.json
├─ tailwind.config.js
├─ postcss.config.cjs
├─ src/
│  ├─ main.tsx
│  ├─ app/App.tsx
│  ├─ api/client.ts
│  ├─ auth/{% if use_azure_auth %}msalConfig.ts{% endif %}
│  ├─ features/
│  │  ├─ {% if use_kanban %}kanban/{% endif %}
│  │  └─ {% if use_dashboard %}dashboard/{% endif %}
│  ├─ components/{ ui/, charts/ }
│  ├─ lib/{ utils/ }
│  ├─ styles/index.css
│  └─ test/setup.ts
├─ public/favicon.svg
├─ package.json
├─ .eslintrc.cjs
├─ .prettierrc.cjs
├─ .cursorrules.md
└─ .github/workflows/ci.yml  (if ci_github_actions)

🐳 Dockerfile (multi-stage, production)
# Dockerfile
# --- Build stage ---
FROM node:20-alpine AS build
WORKDIR /app
ENV CI=true
COPY package.json pnpm-lock.yaml* yarn.lock* package-lock.json* ./
RUN corepack enable || true
RUN (pnpm i || npm i || yarn) --frozen-lockfile || (pnpm i || npm i || yarn)
COPY . .
RUN pnpm build || npm run build || yarn build

# --- Runtime stage ---
FROM nginx:1.27-alpine AS runtime
# Copy Nginx config with SPA fallback + caching
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
# Static assets
COPY --from=build /app/dist /usr/share/nginx/html
# Runtime env injection (env.js), served ahead of app
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Healthcheck: simple curl of root
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost/health || exit 1

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

⚙️ docker/nginx.conf (SPA routing + cache + /env.js + /health)
server {
  listen 80;
  server_name _;

  root /usr/share/nginx/html;

  # Health endpoint (no disk hit)
  location = /health {
    add_header Content-Type text/plain;
    return 200 "ok\n";
  }

  # Runtime env file (do not cache)
  location = /env.js {
    add_header Cache-Control "no-store";
    try_files /env.js =404;
  }

  # Static assets: long cache for hashed files
  location ~* \.(?:js|css|svg|png|jpg|jpeg|gif|webp|ico)$ {
    add_header Cache-Control "public, max-age=31536000, immutable";
    try_files $uri =404;
  }

  # HTML + SPA fallback
  location / {
    try_files $uri /index.html;
  }
}

🏁 docker/entrypoint.sh (runtime env injection)
#!/usr/bin/env sh
set -eu

# Create /env.js from environment variables so we do NOT need rebuilds
# Values prefixed with APP_ are exposed to the client in env.js
# e.g., APP_API_BASE_URL, APP_AZURE_CLIENT_ID, etc.

ENV_JS="/usr/share/nginx/html/env.js"
echo "// Generated at container start" > "$ENV_JS"
echo "window.__ENV__ = {" >> "$ENV_JS"

# Whitelist variables for the client (avoid dumping secrets)
VAR_NAMES="APP_API_BASE_URL APP_AZURE_CLIENT_ID APP_AZURE_TENANT_ID APP_AZURE_API_SCOPE APP_DEV_NO_AUTH"
for name in $VAR_NAMES; do
  val=$(printenv "$name" || true)
  # Properly escape double quotes
  esc=$(printf '%s' "${val:-}" | sed 's/"/\\"/g')
  echo "  $name: \"${esc}\"," >> "$ENV_JS"
done

echo "};" >> "$ENV_JS"

exec "$@"


In your app you can read window.__ENV__?.APP_API_BASE_URL at runtime.

🧩 docker-compose.yml (prod-like, frontend-only + optional backend link)
version: "3.9"

services:
  frontend:
    build:
      context: .
      dockerfile: Dockerfile
    image: {{ package_name }}:latest
    container_name: {{ package_name }}
    environment:
      # Public runtime variables (read by entrypoint to create /env.js)
      APP_API_BASE_URL: ${APP_API_BASE_URL:-http://localhost:8000}
      APP_AZURE_CLIENT_ID: ${APP_AZURE_CLIENT_ID:-dev-client-id}
      APP_AZURE_TENANT_ID: ${APP_AZURE_TENANT_ID:-dev-tenant-id}
      APP_AZURE_API_SCOPE: ${APP_AZURE_API_SCOPE:-api://dev/access_as_user}
      APP_DEV_NO_AUTH: ${APP_DEV_NO_AUTH:-true}
    ports:
      - "${FRONTEND_PORT:-3000}:80"
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost/health"]
      interval: 30s
      timeout: 3s
      retries: 3
    restart: unless-stopped

  # Uncomment and adjust when wiring to a backend
  # backend:
  #   image: your-fastapi-backend:latest
  #   environment:
  #     MONGODB_URI: ${MONGODB_URI}
  #   ports:
  #     - "8000:8000"
  #   depends_on:
  #     - mongo
  #
  # mongo:
  #   image: mongo:7
  #   ports:
  #     - "27017:27017"

🔐 .env.example (safe defaults you can promote)
# Container port mapping for the frontend (host:container)
FRONTEND_PORT=3000

# Public runtime configuration (consumed by /env.js)
APP_API_BASE_URL=http://localhost:8000
APP_AZURE_CLIENT_ID=your-client-id
APP_AZURE_TENANT_ID=your-tenant-id
APP_AZURE_API_SCOPE=api://your-app-id/access_as_user
APP_DEV_NO_AUTH=true


Keep anything secret (tokens, client secrets) out of APP_* and the client. The client bundle + env.js are public.

🧪 package.json (scripts → build, test, docker)
{
  "name": "{{ package_name }}",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .ts,.tsx",
    "format": "prettier --write .",
    "typecheck": "tsc -b --pretty false",
    "test": "vitest run",
    "test:watch": "vitest",
    "docker:build": "docker build -t {{ package_name }}:latest .",
    "docker:up": "docker compose up --build",
    "docker:down": "docker compose down",
    "prepare": "husky install"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.26.1",
    "axios": "^1.7.7",
    "dnd-kit": "^6.1.0",
    "recharts": "^2.12.7",
    {% if use_azure_auth %}"@azure/msal-browser": "^3.16.0",{% endif %}
    "@tanstack/react-query": "^5.56.2"
  },
  "devDependencies": {
    "@types/node": "^20.11.30",
    "@types/react": "^18.3.5",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.3",
    "typescript": "^5.6.2",
    "vite": "^5.4.8",
    "tailwindcss": "^3.4.12",
    "postcss": "^8.4.47",
    "autoprefixer": "^10.4.20",
    "eslint": "^9.11.1",
    "@typescript-eslint/eslint-plugin": "^8.8.1",
    "@typescript-eslint/parser": "^8.8.1",
    "eslint-config-prettier": "^9.1.0",
    "prettier": "^3.3.3",
    "husky": "^9.1.6",
    "lint-staged": "^15.2.9",
    "commitlint": "^19.5.0",
    "@commitlint/config-conventional": "^19.5.0",
    "vitest": "^2.1.3",
    "@testing-library/react": "^16.0.1",
    "@testing-library/jest-dom": "^6.5.0",
    "jsdom": "^25.0.1",
    "playwright": "^1.48.0"
  }
}

🧭 vite.config.ts (tests + path alias)
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'node:path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: { '@': path.resolve(__dirname, './src') }
  },
  test: {
    environment: 'jsdom',
    setupFiles: './src/test/setup.ts',
    css: true,
    coverage: { reporter: ['text', 'lcov'] }
  }
})

🔐 Auth & Runtime env usage (frontend)

index.html should load runtime env.js before your main bundle:

<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{{ project_name }}</title>
    <script src="/env.js"></script>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>


src/api/client.ts (uses runtime base URL):

const RUNTIME = (window as any).__ENV__ || {}
export const API_BASE_URL: string = RUNTIME.APP_API_BASE_URL ?? 'http://localhost:8000'


src/auth/msalConfig.ts (optional, gated by use_azure_auth):

const RUNTIME = (window as any).__ENV__ || {}
export const msalConfig = {
  auth: {
    clientId: RUNTIME.APP_AZURE_CLIENT_ID,
    authority: `https://login.microsoftonline.com/${RUNTIME.APP_AZURE_TENANT_ID}`,
    redirectUri: window.location.origin
  }
}

export const loginRequest = {
  scopes: [RUNTIME.APP_AZURE_API_SCOPE].filter(Boolean)
}

🧪 test setup

src/test/setup.ts

import { afterEach } from 'vitest'
import { cleanup } from '@testing-library/react'
import '@testing-library/jest-dom'
afterEach(() => cleanup())

🧷 Cursor Rules (engineering practices)

.cursorrules.md

# Alkeme Cursor Rules — Frontend

## Architecture
- Feature-first structure in `src/features/*`; shared primitives in `src/components/ui`.
- API access through `src/api/client.ts` with typed helpers.

## TypeScript
- `"strict": true`, no `any` unless justified with comment.
- Prefer `satisfies` and discriminated unions for state.

## Styling
- Tailwind utilities only; shared patterns become small components in `components/ui`.

## Auth
- Dev: `APP_DEV_NO_AUTH=true` lets the app bypass MSAL logic for mocks.
- Prod: MSAL config from `window.__ENV__`.

## Testing
- Vitest + RTL for units; Playwright for smoke/e2e flows.
- CI must run lint + typecheck + tests.

## Commits & CI
- Conventional Commits enforced by commitlint.
- Husky + lint-staged run on pre-commit to keep diffs tidy.

## Accessibility
- Accessible names/roles; keyboard nav verified in Playwright where feasible.

## Performance
- Route-based code splitting; avoid blocking main thread; memoize heavy components.

🧰 CI (optional) — .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  build-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 'lts/*'
          cache: 'pnpm'
      - run: corepack enable
      - run: pnpm i
      - run: pnpm lint
      - run: pnpm typecheck
      - run: pnpm test

  docker:
    if: ${{ github.event_name == 'push' }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t {{ package_name }}:ci .

🏎 Quick commands
# local dev
pnpm dev

# build prod
pnpm build

# docker (prod-like)
cp .env.example .env
docker compose up --build
# open http://localhost:3000 (or FRONTEND_PORT)

✅ What you get at runtime

GET / serves your SPA, with client-side routing supported.

GET /env.js exposes non-secret runtime config (API base URL, Azure IDs).

GET /health for container health checks.

No rebuild required when changing config: update env vars & restart the container.