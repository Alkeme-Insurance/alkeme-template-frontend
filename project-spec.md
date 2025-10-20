# Alkeme Frontend Template - Project Specification

## Overview
This specification outlines the complete implementation of a Copier-based frontend template that generates production-ready React applications with Docker containerization and Azure deployment infrastructure via Bicep.

**Template Goals:**
- Generate Vite + React + TypeScript + Tailwind applications
- Production-ready Docker multi-stage builds
- Runtime environment injection (no rebuild for config changes)
- Azure Container Apps deployment via Bicep
- CI/CD with GitHub Actions
- Feature flags for optional scaffolding (Azure Auth, Kanban, Dashboard)

---

## Phase 1: Template Repository Structure

### Step 1.1: Create Template Root Directory Structure
```
alkeme-template-frontend/
├── copier.yml                           # Copier configuration
├── README.md                            # Template documentation
├── .copier-answers.yml.jinja           # Answer tracking
└── template/                            # Template files (will be rendered)
```

**Action:** Initialize git repository and create base structure
```bash
mkdir alkeme-template-frontend
cd alkeme-template-frontend
git init
```

### Step 1.2: Create copier.yml Configuration
**File:** `copier.yml`

**Content:** Define template questions and configuration
- Template version: 9.2+
- Questions: project_name, package_name, owner_org, feature flags
- Post-generation tasks: git init, npm install, initial commit
- Subdirectory: template/

**Key Fields:**
- `_min_copier_version: "9.2"`
- `_subdirectory: template`
- `_templates_suffix: .jinja`
- Questions: project_name, package_name, owner_org, use_azure_auth, use_kanban, use_dashboard, ci_github_actions, azure_subscription_id, azure_resource_group

### Step 1.3: Create Template Answers File
**File:** `.copier-answers.yml.jinja`

**Purpose:** Track user answers for template updates

---

## Phase 2: Template Files - Core Application

### Step 2.1: Package Configuration
**Files to Create:**
- `template/package.json.jinja` - NPM package definition with scripts
- `template/tsconfig.json` - TypeScript configuration (strict mode)
- `template/tsconfig.node.json` - TypeScript config for build tools

**Dependencies:**
- React 18.3+
- React Router DOM 6.26+
- Axios 1.7+
- TanStack Query 5.56+
- Conditional: @azure/msal-browser (if use_azure_auth)
- Conditional: @dnd-kit/core (if use_kanban)
- Conditional: recharts (if use_dashboard)

**Dev Dependencies:**
- Vite 5.4+
- TypeScript 5.6+
- Tailwind 3.4+
- ESLint 9+ with TypeScript plugins
- Prettier 3.3+
- Vitest 2.1+
- Testing Library
- Husky + lint-staged + commitlint
- Playwright 1.48+

**Scripts:**
```json
{
  "dev": "vite",
  "build": "tsc -b && vite build",
  "preview": "vite preview",
  "lint": "eslint . --ext .ts,.tsx",
  "format": "prettier --write .",
  "typecheck": "tsc -b --pretty false",
  "test": "vitest run",
  "test:watch": "vitest",
  "docker:build": "docker build -t {{package_name}}:latest .",
  "docker:up": "docker compose up --build",
  "docker:down": "docker compose down",
  "prepare": "husky install"
}
```

### Step 2.2: Build Tool Configuration
**Files to Create:**
- `template/vite.config.ts.jinja` - Vite configuration with path aliases, test setup
- `template/tailwind.config.js.jinja` - Tailwind theme and content paths
- `template/postcss.config.cjs` - PostCSS with autoprefixer
- `template/.eslintrc.cjs.jinja` - ESLint rules (TypeScript, React, Prettier)
- `template/.prettierrc.cjs` - Prettier formatting rules
- `template/.gitignore` - Standard Node/Vite ignores

### Step 2.3: Application Entry Points
**Files to Create:**
- `template/index.html.jinja` - HTML shell with /env.js script tag
- `template/src/main.tsx.jinja` - React app mount point
- `template/src/app/App.tsx.jinja` - Root component with routing
- `template/src/styles/index.css` - Tailwind directives + custom styles

**index.html Requirements:**
- Load `/env.js` before main bundle
- Meta tags for charset, viewport
- Title from {{project_name}}

### Step 2.4: Core Application Code
**Directory Structure:**
```
template/src/
├── main.tsx.jinja
├── app/
│   ├── App.tsx.jinja
│   └── routes.tsx.jinja
├── api/
│   └── client.ts.jinja              # Axios instance with runtime base URL
├── auth/
│   {% if use_azure_auth %}
│   ├── msalConfig.ts.jinja          # MSAL configuration from window.__ENV__
│   ├── AuthProvider.tsx.jinja       # MSAL React provider
│   └── useAuth.ts.jinja             # Auth hook
│   {% endif %}
├── features/
│   {% if use_kanban %}
│   └── kanban/
│       ├── KanbanBoard.tsx.jinja    # dnd-kit implementation
│       └── types.ts.jinja
│   {% endif %}
│   {% if use_dashboard %}
│   └── dashboard/
│       ├── Dashboard.tsx.jinja      # KPI dashboard with recharts
│       └── types.ts.jinja
│   {% endif %}
├── components/
│   └── ui/                          # Shared UI components
│       ├── Button.tsx.jinja
│       ├── Card.tsx.jinja
│       └── LoadingSpinner.tsx.jinja
├── lib/
│   └── utils.ts                     # Utility functions (cn for classnames)
├── test/
│   └── setup.ts                     # Vitest + Testing Library setup
└── styles/
    └── index.css                    # Tailwind + custom styles
```

**Key Implementation Details:**

**src/api/client.ts.jinja:**
```typescript
const RUNTIME = (window as any).__ENV__ || {}
export const API_BASE_URL: string = RUNTIME.APP_API_BASE_URL ?? 'http://localhost:8000'

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: { 'Content-Type': 'application/json' }
})
```

**src/auth/msalConfig.ts.jinja (conditional):**
```typescript
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
```

### Step 2.5: Testing Setup
**Files to Create:**
- `template/src/test/setup.ts` - Vitest + Testing Library configuration
- `template/playwright.config.ts.jinja` - Playwright E2E configuration
- `template/src/app/App.test.tsx.jinja` - Sample component test

---

## Phase 3: Docker Configuration

### Step 3.1: Multi-Stage Dockerfile
**File:** `template/Dockerfile`

**Stages:**
1. **Build Stage** (node:20-alpine)
   - Copy package files
   - Install dependencies with npm
   - Copy source code
   - Build production bundle

2. **Runtime Stage** (nginx:1.27-alpine)
   - Copy nginx.conf
   - Copy built assets from build stage
   - Copy entrypoint.sh for runtime env injection
   - Add healthcheck endpoint
   - Expose port 80

**Key Features:**
- Multi-stage build for minimal image size
- Automatic lock file detection
- Healthcheck: `wget -qO- http://localhost/health`
- Entrypoint script for environment injection

### Step 3.2: Nginx Configuration
**File:** `template/docker/nginx.conf`

**Routes:**
- `/health` - Returns 200 "ok" (for healthchecks)
- `/env.js` - Runtime environment variables (Cache-Control: no-store)
- Static assets (*.js, *.css, images) - Long-term cache with immutability
- `/` - SPA fallback (try_files $uri /index.html)

**Configuration:**
- Listen on port 80
- Gzip compression
- Proper MIME types
- Security headers (optional: CSP, X-Frame-Options)

### Step 3.3: Runtime Environment Injection
**File:** `template/docker/entrypoint.sh`

**Purpose:** Generate `/usr/share/nginx/html/env.js` at container startup

**Process:**
1. Create window.__ENV__ object
2. Whitelist safe environment variables (APP_* prefix)
3. Escape values properly for JavaScript
4. Write /env.js before Nginx starts

**Whitelisted Variables:**
- APP_API_BASE_URL
- APP_AZURE_CLIENT_ID
- APP_AZURE_TENANT_ID
- APP_AZURE_API_SCOPE
- APP_DEV_NO_AUTH

**Security:** Never expose secrets or backend tokens to the client

### Step 3.4: Docker Compose
**File:** `template/docker-compose.yml.jinja`

**Services:**
- **frontend** - Main application container
  - Build from local Dockerfile
  - Environment variables from .env
  - Port mapping: ${FRONTEND_PORT:-3000}:80
  - Healthcheck configuration
  - Restart policy: unless-stopped

- **backend** (commented stub for future integration)
- **mongo** (commented stub for future integration)

### Step 3.5: Environment Configuration
**File:** `template/.env.example`

**Variables:**
```bash
# Port mapping
FRONTEND_PORT=3000

# Public runtime configuration
APP_API_BASE_URL=http://localhost:8000
APP_AZURE_CLIENT_ID=your-client-id
APP_AZURE_TENANT_ID=your-tenant-id
APP_AZURE_API_SCOPE=api://your-app-id/access_as_user
APP_DEV_NO_AUTH=true
```

---

## Phase 4: Azure Deployment Infrastructure

### Step 4.1: Bicep Module Structure
**Directory:** `template/infra/`

```
template/infra/
├── main.bicep                       # Main deployment orchestrator
├── modules/
│   ├── container-registry.bicep     # Azure Container Registry
│   ├── container-app.bicep          # Azure Container App
│   ├── log-analytics.bicep          # Log Analytics Workspace
│   ├── app-insights.bicep           # Application Insights
│   └── managed-identity.bicep       # User-assigned managed identity
├── main.bicepparam.jinja            # Parameter file template
└── README.md.jinja                  # Deployment documentation
```

### Step 4.2: Main Bicep Template
**File:** `template/infra/main.bicep`

**Parameters:**
- projectName (string) - Base name for all resources
- environmentName (string) - dev/staging/prod
- location (string, default: resourceGroup().location)
- containerImage (string) - Full ACR image path
- azureClientId (string, secure)
- azureTenantId (string, secure)
- apiBaseUrl (string)
- frontendPort (int, default: 80)

**Resources to Deploy:**
1. Log Analytics Workspace
2. Application Insights
3. Container Registry (with admin enabled for CI)
4. User-Assigned Managed Identity
5. Container App Environment
6. Container App

**Outputs:**
- containerAppFQDN (string) - Public URL
- containerRegistryLoginServer (string)
- containerRegistryName (string)

### Step 4.3: Container Registry Module
**File:** `template/infra/modules/container-registry.bicep`

**Features:**
- SKU: Basic (upgradable to Standard/Premium)
- Admin user enabled for CI/CD
- Public network access
- Tag: environment

**Outputs:**
- loginServer
- name
- adminUsername (for CI)

### Step 4.4: Container App Module
**File:** `template/infra/modules/container-app.bicep`

**Configuration:**
- Scale rules: 1-3 replicas based on HTTP traffic
- Resource limits: 0.5 CPU, 1GB memory
- Ingress: External, port 80, allowInsecure: false
- Environment variables from parameters
- Pull from ACR using managed identity
- Health probes: HTTP /health endpoint

**Environment Variables:**
- APP_API_BASE_URL
- APP_AZURE_CLIENT_ID
- APP_AZURE_TENANT_ID
- APP_AZURE_API_SCOPE
- APP_DEV_NO_AUTH (false in production)

### Step 4.5: Log Analytics & App Insights Modules
**Files:**
- `template/infra/modules/log-analytics.bicep`
- `template/infra/modules/app-insights.bicep`

**Purpose:**
- Centralized logging for Container App
- Application performance monitoring
- Real user monitoring (RUM)
- Link App Insights to Log Analytics workspace

### Step 4.6: Managed Identity Module
**File:** `template/infra/modules/managed-identity.bicep`

**Purpose:**
- User-assigned identity for Container App
- Pull images from ACR without credentials
- Potential for accessing Key Vault for secrets

### Step 4.7: Bicep Parameters File
**File:** `template/infra/main.bicepparam.jinja`

**Content:**
```bicep
using './main.bicep'

param projectName = '{{package_name}}'
param environmentName = 'dev'
param location = 'eastus'
param containerImage = '{{package_name}}.azurecr.io/{{package_name}}:latest'
param azureClientId = 'your-client-id'
param azureTenantId = 'your-tenant-id'
param apiBaseUrl = 'https://api.yourdomain.com'
```

### Step 4.8: Deployment Scripts
**File:** `template/infra/deploy.sh.jinja`

**Script Actions:**
1. Login to Azure CLI
2. Set subscription
3. Create resource group (if not exists)
4. Deploy Bicep template
5. Output deployment results
6. Show Container App URL

**File:** `template/infra/deploy-ci.sh.jinja`

**Purpose:** Non-interactive deployment for CI/CD
- Use service principal credentials
- No prompts
- Fail fast on errors
- Output JSON for parsing

---

## Phase 5: CI/CD Configuration

### Step 5.1: GitHub Actions Workflow
**File:** `template/.github/workflows/ci.yml.jinja` (conditional: ci_github_actions)

**Triggers:**
- Push to main branch
- Pull requests

**Jobs:**

**1. lint-type-test:**
- Runs on: ubuntu-latest
- Steps:
  - Checkout code
  - Setup Node.js (LTS, npm cache)
  - Install dependencies
  - Run lint
  - Run typecheck
  - Run tests with coverage
  - Upload coverage to Codecov (optional)

**2. docker-build:**
- Runs on: ubuntu-latest
- Condition: Push to main only
- Steps:
  - Checkout code
  - Build Docker image locally (validation)

**3. deploy-azure:**
- Runs on: ubuntu-latest
- Condition: Push to main + success of previous jobs
- Environment: production
- Steps:
  - Checkout code
  - Azure Login (with service principal)
  - ACR Login
  - Docker build with full ACR tag
  - Docker push to ACR
  - Deploy Bicep template (with new image tag)
  - Comment PR/commit with deployment URL

### Step 5.2: Azure Service Principal Setup Documentation
**File:** `template/.github/AZURE_SETUP.md.jinja`

**Instructions:**
1. Create service principal: `az ad sp create-for-rbac`
2. Grant ACR push permissions
3. Grant Contributor role on resource group
4. Add GitHub secrets:
   - AZURE_CLIENT_ID
   - AZURE_CLIENT_SECRET
   - AZURE_TENANT_ID
   - AZURE_SUBSCRIPTION_ID
   - ACR_LOGIN_SERVER
   - APP_AZURE_CLIENT_ID (MSAL)
   - APP_AZURE_TENANT_ID (MSAL)

### Step 5.3: Branch Protection & Deployment Gates
**Documentation for:**
- Required status checks (lint, test, docker-build)
- Review requirements
- Environment protection rules in GitHub
- Manual approval for production deployments

---

## Phase 6: Developer Experience & Documentation

### Step 6.1: Cursor Rules
**File:** `template/.cursorrules.md.jinja`

**Content Sections:**
1. **Architecture** - Feature-first structure, API client patterns
2. **TypeScript** - Strict mode, no any, prefer satisfies
3. **Styling** - Tailwind utilities only
4. **Auth** - Dev mode bypass, MSAL runtime config
5. **Testing** - Vitest + RTL for units, Playwright for E2E
6. **Commits & CI** - Conventional Commits, Husky hooks
7. **Accessibility** - ARIA labels, keyboard navigation
8. **Performance** - Code splitting, memoization

### Step 6.2: Git Hooks Configuration
**Files:**
- `template/.husky/pre-commit` - Run lint-staged
- `template/.husky/commit-msg` - Run commitlint
- `template/.lintstagedrc.json` - Lint & format staged files
- `template/.commitlintrc.json` - Conventional Commits rules

### Step 6.3: Main README
**File:** `template/README.md.jinja`

**Sections:**
1. Project title and description
2. Prerequisites (Node, Docker, Azure CLI)
3. Quick start (local development)
4. Docker development
5. Azure deployment
6. Environment variables reference
7. Project structure
8. Available scripts
9. Testing strategy
10. Contributing guidelines
11. License

### Step 6.4: Deployment README
**File:** `template/infra/README.md.jinja`

**Sections:**
1. Azure prerequisites
2. One-time setup (service principal, ACR)
3. Manual deployment steps
4. CI/CD deployment (automated)
5. Updating configuration
6. Monitoring and logs
7. Scaling configuration
8. Costs estimation
9. Troubleshooting

### Step 6.5: Public Assets
**Files:**
- `template/public/favicon.svg` - Default favicon
- `template/public/robots.txt` - SEO configuration
- `template/public/.well-known/security.txt` (optional)

---

## Phase 7: Testing & Validation

### Step 7.1: Template Testing Strategy
**Create:** `tests/` directory in template repo root (not rendered)

**Test Files:**
- `tests/test_template_generation.py` - Test Copier rendering
- `tests/test_docker_build.sh` - Validate Docker build succeeds
- `tests/test_azure_bicep.sh` - Validate Bicep template

**Test Process:**
1. Generate project with Copier (various option combinations)
2. Verify all files created
3. Run npm install
4. Run lint, typecheck, test
5. Build Docker image
6. Validate Bicep with `az bicep build`
7. Test deployment to dev environment

### Step 7.2: Example Projects
**Create:** `examples/` directory

**Example Variations:**
- Minimal (no Azure auth, no features)
- Full-featured (all flags enabled)
- Azure auth only
- Each with working deployment

### Step 7.3: CI for Template Repository
**File:** `.github/workflows/test-template.yml`

**Jobs:**
- Test template generation with all option combinations
- Validate generated projects build successfully
- Run generated project tests
- Validate Docker builds
- Lint Bicep templates
- Deploy to test Azure subscription (on main push)

---

## Phase 8: Template Repository Documentation

### Step 8.1: Template README
**File:** `README.md` (in template repo root)

**Content:**
1. What this template generates
2. Features and capabilities
3. Prerequisites for using template
4. Usage: `copier copy gh:alkeme/alkeme-template-frontend my-app`
5. Template options reference
6. Post-generation steps
7. Updating projects from template
8. Contributing to template
9. Support and issues

### Step 8.2: Template Contribution Guide
**File:** `CONTRIBUTING.md`

**Sections:**
- How to modify template
- Testing changes locally
- Adding new optional features
- Updating dependencies
- Release process
- Code of conduct

### Step 8.3: Changelog
**File:** `CHANGELOG.md`

**Format:** Keep a Changelog format
- Unreleased section
- Version history with dates
- Categories: Added, Changed, Deprecated, Removed, Fixed, Security

### Step 8.4: License
**File:** `LICENSE`

**Recommendation:** MIT License

---

## Phase 9: Optional Enhancements

### Step 9.1: Advanced Azure Features
**Optional Modules:**

1. **Azure Front Door** (`template/infra/modules/front-door.bicep`)
   - Global CDN
   - WAF rules
   - SSL certificate management

2. **Key Vault** (`template/infra/modules/key-vault.bicep`)
   - Secret management
   - Certificate storage
   - Managed identity access

3. **Cosmos DB** (for backend future integration)
   - MongoDB API
   - Connection string in Key Vault

4. **Azure Static Web Apps** (alternative deployment target)
   - Copier flag: use_static_web_apps vs use_container_apps

### Step 9.2: Additional Feature Scaffolds
**Optional Features (new Copier flags):**

1. `use_analytics` - Google Analytics/Plausible integration
2. `use_i18n` - react-i18next setup with language switching
3. `use_pwa` - PWA manifest + service worker
4. `use_storybook` - Storybook for component development
5. `use_cypress` - Cypress E2E (alternative to Playwright)

### Step 9.3: Multi-Environment Support
**Enhancement:** Generate separate parameter files per environment

**Files:**
- `template/infra/main.dev.bicepparam.jinja`
- `template/infra/main.staging.bicepparam.jinja`
- `template/infra/main.prod.bicepparam.jinja`

**CI/CD Enhancement:** Deploy to dev on PR, staging on main, prod on tag

### Step 9.4: Monitoring & Observability
**Additional Modules:**

1. **Application Map** - Service dependencies visualization
2. **Custom Metrics** - Tailored dashboards
3. **Alerts** - Error rate, latency, availability
4. **Workbooks** - Custom Azure Monitor workbooks

---

## Implementation Checklist

### Pre-Flight
- [ ] Install Copier 9.2+ locally
- [ ] Set up test Azure subscription
- [ ] Create GitHub organization/repo for template
- [ ] Prepare sample branding assets (logo, favicon)

### Phase 1: Foundation (Week 1)
- [ ] Initialize template repository
- [ ] Create copier.yml with all questions
- [ ] Define directory structure
- [ ] Set up template testing framework
- [ ] Document template usage

### Phase 2: Core Application (Week 1-2)
- [ ] Configure package.json with all dependencies
- [ ] Set up TypeScript, ESLint, Prettier configs
- [ ] Create Vite configuration
- [ ] Implement App.tsx with routing
- [ ] Create API client with runtime env support
- [ ] Implement Azure MSAL integration (conditional)
- [ ] Create Kanban feature scaffold (conditional)
- [ ] Create Dashboard feature scaffold (conditional)
- [ ] Add shared UI components
- [ ] Set up Vitest + Testing Library
- [ ] Add Playwright E2E setup
- [ ] Test local development flow

### Phase 3: Docker (Week 2)
- [ ] Create multi-stage Dockerfile
- [ ] Configure Nginx with SPA routing
- [ ] Implement entrypoint.sh for env injection
- [ ] Create docker-compose.yml
- [ ] Create .env.example
- [ ] Test Docker build and run locally
- [ ] Verify runtime env injection works
- [ ] Test healthcheck endpoint

### Phase 4: Azure Infrastructure (Week 2-3)
- [ ] Create main.bicep orchestrator
- [ ] Implement Container Registry module
- [ ] Implement Log Analytics module
- [ ] Implement App Insights module
- [ ] Implement Managed Identity module
- [ ] Implement Container App module
- [ ] Create parameter file template
- [ ] Write deployment scripts
- [ ] Test deployment to Azure dev environment
- [ ] Verify Container App runs correctly
- [ ] Test MSAL authentication in Azure
- [ ] Document Azure setup process

### Phase 5: CI/CD (Week 3)
- [ ] Create GitHub Actions workflow
- [ ] Configure lint-type-test job
- [ ] Configure docker-build job
- [ ] Configure deploy-azure job
- [ ] Set up Azure service principal
- [ ] Configure GitHub secrets
- [ ] Test full CI/CD pipeline
- [ ] Document service principal setup
- [ ] Add deployment status badges

### Phase 6: Developer Experience (Week 3-4)
- [ ] Write Cursor rules
- [ ] Configure Husky + lint-staged
- [ ] Configure commitlint
- [ ] Write comprehensive README
- [ ] Write infrastructure README
- [ ] Create deployment documentation
- [ ] Add troubleshooting guide
- [ ] Create contribution guidelines

### Phase 7: Testing & Quality (Week 4)
- [ ] Write template generation tests
- [ ] Create example projects (minimal, full)
- [ ] Test all feature flag combinations
- [ ] Validate Docker builds for all variations
- [ ] Test Azure deployments
- [ ] Performance test Container App
- [ ] Security scan Docker images
- [ ] Accessibility audit with Lighthouse

### Phase 8: Documentation & Release (Week 4)
- [ ] Write template README
- [ ] Create CONTRIBUTING.md
- [ ] Initialize CHANGELOG.md
- [ ] Add LICENSE file
- [ ] Create template usage examples
- [ ] Record demo video (optional)
- [ ] Publish to GitHub with copier-template topic
- [ ] Announce in team/community

### Phase 9: Optional Enhancements (Future)
- [ ] Add Azure Front Door support
- [ ] Add Key Vault integration
- [ ] Add i18n support
- [ ] Add PWA capabilities
- [ ] Add Storybook setup
- [ ] Multi-environment parameter files
- [ ] Custom monitoring dashboards
- [ ] Cost optimization recommendations

---

## Key Decision Points

### 1. Container Deployment Target
**Options:**
- **Azure Container Apps** (recommended) - Serverless, automatic scaling, easy deployment
- **Azure Static Web Apps** - Simple, cost-effective for pure frontend, no Docker
- **Azure App Service** (Containers) - More control, traditional PaaS

**Recommendation:** Start with Container Apps (most flexible)

### 2. Authentication Strategy
**Options:**
- **Azure AD (MSAL.js)** - Enterprise SSO, B2B scenarios
- **Azure AD B2C** - Consumer identity, social logins
- **Auth0 / Okta** - Multi-platform support
- **Custom JWT** - Full control, more work

**Recommendation:** Azure AD (MSAL.js) as default, make pluggable

### 3. CI/CD Platform
**Options:**
- **GitHub Actions** (recommended) - Native, free for public repos
- **Azure DevOps Pipelines** - Enterprise features, Azure-native
- **GitLab CI** - Self-hosted option

**Recommendation:** GitHub Actions (most accessible)

### 4. Environment Variable Management
**Options:**
- **Runtime injection** (current approach) - No rebuild needed
- **Build-time injection** - Simpler, requires rebuild per environment
- **Azure App Configuration** - Centralized, more complex

**Recommendation:** Runtime injection for flexibility

### 5. Monitoring & Observability
**Options:**
- **Azure Application Insights** (recommended) - Native, comprehensive
- **Datadog** - Multi-cloud, powerful
- **New Relic** - APM focused
- **Sentry** - Error tracking

**Recommendation:** Application Insights (Azure-native)

---

## Success Criteria

### For Generated Projects:
✅ Application builds successfully with zero errors
✅ All tests pass (lint, typecheck, unit, e2e)
✅ Docker image builds and runs locally
✅ Azure deployment succeeds via Bicep
✅ Container App serves application with HTTPS
✅ Runtime environment injection works correctly
✅ MSAL authentication flows work (if enabled)
✅ Healthcheck endpoint responds correctly
✅ Application loads in <3s on Container Apps
✅ No accessibility violations (Lighthouse score >90)
✅ CI/CD pipeline completes in <10 minutes

### For Template Itself:
✅ Template generates successfully for all option combinations
✅ Clear, comprehensive documentation
✅ Working examples for common scenarios
✅ Automated testing validates template quality
✅ Version control tracks user answers for updates
✅ Update workflow preserves user customizations
✅ Community can contribute improvements
✅ Listed in Copier template gallery

---

## Maintenance & Updates

### Regular Tasks:
- **Monthly:** Update dependencies to latest stable versions
- **Quarterly:** Review Azure best practices, update Bicep templates
- **As needed:** Security patches, critical bug fixes

### Version Strategy:
- **Major (X.0.0):** Breaking changes, major new features
- **Minor (1.X.0):** New optional features, backward-compatible
- **Patch (1.0.X):** Bug fixes, documentation updates

### Update Workflow for Generated Projects:
```bash
# Users can pull template updates
copier update
# Copier merges changes, preserving customizations
```

---

## Resources & References

### Copier Documentation
- [Copier Official Docs](https://copier.readthedocs.io/en/stable/)
- [Creating Templates](https://copier.readthedocs.io/en/stable/creating/)
- [Configuring Templates](https://copier.readthedocs.io/en/stable/configuring/)

### Azure Documentation
- [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Azure Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/)
- [MSAL.js](https://learn.microsoft.com/en-us/azure/active-directory/develop/msal-overview)

### Tech Stack
- [Vite](https://vitejs.dev/)
- [React 18](https://react.dev/)
- [TypeScript](https://www.typescriptlang.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [React Router](https://reactrouter.com/)
- [TanStack Query](https://tanstack.com/query/latest)

### Testing
- [Vitest](https://vitest.dev/)
- [Testing Library](https://testing-library.com/react)
- [Playwright](https://playwright.dev/)

---

## Timeline Summary

**Week 1:** Foundation + Core Application
**Week 2:** Docker + Azure Infrastructure  
**Week 3:** CI/CD + Developer Experience
**Week 4:** Testing + Documentation + Release

**Total:** 4 weeks for production-ready template
**Optional Enhancements:** Ongoing

---

## Next Steps

1. **Review this specification** with team for feedback
2. **Set up template repository** on GitHub
3. **Create initial copier.yml** with basic structure
4. **Implement Phase 1 & 2** (Foundation + Core App)
5. **Test locally** before proceeding to Docker/Azure phases
6. **Iterate based on real usage** and team feedback

---

*This specification is a living document. Update as you learn from implementation and usage.*

