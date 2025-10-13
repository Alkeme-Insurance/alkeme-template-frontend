# Docker Quick Start Guide

## 🎯 Quick Test Commands

### Test Template Generation
```bash
# Generate a test project
cd /home/jharris/workspace
uvx copier copy /home/jharris/workspace/alkeme-template-frontend /tmp/test-project --defaults --trust --skip-tasks

# View generated files
ls -la /tmp/test-project/
ls -la /tmp/test-project/docker/
```

### Verify Docker Files
```bash
cd /tmp/test-project

# Check Dockerfile
head -10 Dockerfile

# Check nginx config
head -20 docker/nginx.conf

# Check entrypoint script
head -20 docker/entrypoint.sh

# Check docker-compose
cat docker-compose.yml
```

---

## 🐳 Build & Run (Once Source Code is Added)

### Step 1: Set Up Environment
```bash
cd /tmp/test-project

# Copy environment template
cp env.example .env

# Edit with your values
nano .env
```

### Step 2: Build Docker Image
```bash
# Build the image
docker build -t alkeme-template-frontend:latest .

# Check image size
docker images | grep alkeme-template-frontend
```

### Step 3: Run with Docker Compose
```bash
# Start services
docker compose up --build

# Run in background
docker compose up -d

# View logs
docker compose logs -f frontend

# Stop services
docker compose down
```

### Step 4: Test Endpoints
```bash
# Health check
curl http://localhost:3000/health
# Should return: ok

# Runtime environment (once app is built)
curl http://localhost:3000/env.js
# Should show window.__ENV__ object

# Application
open http://localhost:3000
```

---

## 🔧 Docker Commands Reference

### Build & Run
```bash
# Build only
docker build -t alkeme-template-frontend:latest .

# Run container manually
docker run -d \
  --name alkeme-frontend \
  -p 3000:80 \
  -e APP_API_BASE_URL=http://localhost:8000 \
  -e APP_AZURE_CLIENT_ID=your-client-id \
  alkeme-template-frontend:latest

# View logs
docker logs -f alkeme-frontend

# Stop and remove
docker stop alkeme-frontend
docker rm alkeme-frontend
```

### Debugging
```bash
# Enter running container
docker exec -it alkeme-frontend sh

# Check nginx config
docker exec alkeme-frontend cat /etc/nginx/conf.d/default.conf

# Check env.js
docker exec alkeme-frontend cat /usr/share/nginx/html/env.js

# Check nginx error logs
docker exec alkeme-frontend cat /var/log/nginx/error.log

# Check if health endpoint works
docker exec alkeme-frontend wget -qO- http://localhost/health
```

### Cleanup
```bash
# Remove all containers
docker compose down

# Remove with volumes
docker compose down -v

# Remove images
docker rmi alkeme-template-frontend:latest

# Clean up test projects
rm -rf /tmp/test-project
```

---

## 🧪 Testing Runtime Environment Injection

### Test 1: Verify env.js Generation
```bash
# Start container
docker compose up -d

# Check if env.js was created
docker exec alkeme-template-frontend ls -la /usr/share/nginx/html/env.js

# View env.js content
docker exec alkeme-template-frontend cat /usr/share/nginx/html/env.js
```

Expected output:
```javascript
// Generated at container startup - DO NOT EDIT
window.__ENV__ = {
  APP_API_BASE_URL: "http://localhost:8000",
  APP_AZURE_CLIENT_ID: "your-client-id",
  APP_AZURE_TENANT_ID: "your-tenant-id",
  APP_AZURE_API_SCOPE: "api://your-app-id/access_as_user",
  APP_DEV_NO_AUTH: "true",
  APP_ENVIRONMENT: "development",
};
```

### Test 2: Change Config Without Rebuild
```bash
# Update .env file
echo "APP_API_BASE_URL=https://api.production.com" >> .env

# Restart container (no rebuild!)
docker compose restart

# Verify new value
docker exec alkeme-template-frontend cat /usr/share/nginx/html/env.js | grep APP_API_BASE_URL
```

---

## 📊 Verify Template Configuration

### Check copier.yml Settings
```bash
cd /home/jharris/workspace/alkeme-template-frontend

# View Docker-related settings
grep -A 5 "docker_port:" copier.yml
grep -A 5 "include_docker:" copier.yml
grep -A 5 "api_base_url_dev:" copier.yml
```

### Check Template Files
```bash
# List all template files
find template -name "*.jinja" | sort

# Check Dockerfile template
head -20 template/Dockerfile.jinja

# Check if variables are properly used
grep "{{ project_name }}" template/*.jinja
grep "{{ package_name }}" template/*.jinja
```

---

## 🎯 Production Deployment Preview

### Build for Production
```bash
# Build with specific tag
docker build -t myregistry.azurecr.io/alkeme-frontend:1.0.0 .

# Tag as latest
docker tag myregistry.azurecr.io/alkeme-frontend:1.0.0 \
           myregistry.azurecr.io/alkeme-frontend:latest

# Push to registry
docker push myregistry.azurecr.io/alkeme-frontend:1.0.0
docker push myregistry.azurecr.io/alkeme-frontend:latest
```

### Run in Production Mode
```bash
docker run -d \
  --name alkeme-frontend-prod \
  -p 443:80 \
  -e APP_API_BASE_URL=https://api.production.com \
  -e APP_AZURE_CLIENT_ID=prod-client-id \
  -e APP_AZURE_TENANT_ID=prod-tenant-id \
  -e APP_DEV_NO_AUTH=false \
  -e APP_ENVIRONMENT=production \
  --restart unless-stopped \
  myregistry.azurecr.io/alkeme-frontend:1.0.0
```

---

## 🔍 Troubleshooting

### Container Won't Start
```bash
# Check logs
docker compose logs frontend

# Common issues:
# 1. Port already in use
lsof -i :3000
# Change FRONTEND_PORT in .env

# 2. Build failed
docker compose build --no-cache

# 3. Permission issues
chmod +x docker/entrypoint.sh
```

### Health Check Failing
```bash
# Test health endpoint
curl -v http://localhost:3000/health

# Check nginx is running
docker exec alkeme-template-frontend ps aux | grep nginx

# Check nginx config syntax
docker exec alkeme-template-frontend nginx -t
```

### env.js Not Loading
```bash
# Verify env.js exists
docker exec alkeme-template-frontend cat /usr/share/nginx/html/env.js

# Check nginx logs
docker exec alkeme-template-frontend tail -f /var/log/nginx/error.log

# Test env.js endpoint
curl -v http://localhost:3000/env.js
```

### SPA Routing Not Working
```bash
# Check nginx config
docker exec alkeme-template-frontend cat /etc/nginx/conf.d/default.conf | grep try_files

# Should see: try_files $uri /index.html;

# Test 404 handling
curl -v http://localhost:3000/nonexistent-route
# Should return index.html, not 404
```

---

## ✅ Success Checklist

- [x] Template generates without errors
- [x] Dockerfile uses multi-stage build
- [x] nginx.conf has SPA routing
- [x] entrypoint.sh generates env.js
- [x] docker-compose.yml includes all services
- [x] env.example documents all variables
- [x] .dockerignore excludes node_modules
- [x] .gitignore excludes .env files
- [ ] Application source code added
- [ ] Docker build succeeds
- [ ] Container starts successfully
- [ ] Health endpoint returns 200
- [ ] env.js is generated correctly
- [ ] SPA routing works
- [ ] Static assets are cached

---

## 📚 Next Steps

1. **Add Source Code**
   - Create React application files
   - Add TypeScript configuration
   - Implement API client with window.__ENV__

2. **Test Full Build**
   - Run `docker build`
   - Verify build artifacts in dist/
   - Test final image

3. **Deploy to Azure**
   - Create Azure Container Registry
   - Push image
   - Deploy to Container Apps

---

**Ready to add the React application source code!** 🚀

