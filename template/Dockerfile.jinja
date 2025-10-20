# Dockerfile - Multi-stage build for {{ project_name }}
# Production-ready React + Vite application with Nginx

# --- Build stage ---
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci --prefer-offline || npm install

# Copy source code
COPY . .

# Build production bundle
RUN npm run build

# --- Runtime stage ---
FROM nginx:1.27-alpine AS runtime

# Copy custom Nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Copy built static assets from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy runtime environment injection script
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

