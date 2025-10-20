# Alkeme Frontend Template

A production-ready **Copier** template for generating modern React + TypeScript frontend applications with Docker containerization, Azure AD authentication, and best practices built-in.

## 🚀 Features

### Core Stack
- **React 18** with TypeScript
- **Vite** - Lightning-fast build tool with HMR
- **Tailwind CSS** - Utility-first CSS framework
- **React Router** - Client-side routing
- **Axios** - HTTP client with interceptors

### Authentication & Security
- **Azure AD (MSAL.js)** - Enterprise SSO authentication (optional)
- **Protected Routes** - Route guards for authenticated pages
- **Secret Scanning** - Pre-commit hooks to prevent credential leaks
- **Runtime Environment Injection** - No rebuild needed for config changes

### Docker & Deployment
- **Multi-stage Dockerfile** - Optimized production builds
- **Docker Compose** - Multi-service orchestration
- **Nginx** - Production-ready static file server with SPA routing
- **Health Checks** - Container health monitoring
- **Azure Container Apps** - Ready for cloud deployment

### Developer Experience
- **ESLint + Prettier** - Code linting and formatting
- **Vitest** - Fast unit/integration testing
- **Git Hooks** - Automated code quality checks
- **TypeScript** - Full type safety
- **Cursor Rules** - AI assistant configuration for consistent coding

### Package Manager
Uses npm as the standard Node.js package manager.

## 📋 Prerequisites

- **Python 3.10+** (for Copier)
- **Node.js 20+** (for generated project)
- **Docker** (optional, for containerization)
- **Git** (for version control)

## 🎯 Quick Start

### 1. Install Copier

Using `uvx` (recommended):
```bash
# No installation needed - uvx runs copier directly
uvx copier copy gh:Alkeme-Insurance/alkeme-template-frontend my-new-app
```

Or install globally:
```bash
pip install copier
copier copy gh:Alkeme-Insurance/alkeme-template-frontend my-new-app
```

Or use local template:
```bash
uvx copier copy /path/to/alkeme-template-frontend my-new-app
```

### 2. Answer Configuration Questions

Copier will prompt you for:
- **Project name** - Your project identifier (e.g., `my-app`)
- **Package name** - NPM package name (e.g., `@company/my-app`)
- **Description** - Brief project description
- **Author information** - Name and email
- **Features** - Azure Auth, PWA, Analytics (Microsoft Clarity), Git Hooks
- **Docker** - Include Dockerfile and docker-compose.yml
- **Project structure** - Select directories to scaffold in `src/`

### 3. Navigate and Install Dependencies

```bash
cd my-new-app
npm install
```

### 4. Set Up Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your configuration
nano .env
```

### 5. Start Development Server

```bash
npm run dev
```

Visit http://localhost:3000

## 📦 Template Options

### Project Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `project_name` | string | - | Project identifier (kebab-case) |
| `package_name` | string | - | NPM package name |
| `project_description` | string | - | Brief description |
| `author_name` | string | - | Your name |
| `author_email` | string | - | Your email address |

### Features

| Feature | Default | Description |
|---------|---------|-------------|
| `use_azure_auth` | ✓ | Azure AD authentication with MSAL.js |
| `use_pwa` | ✗ | Progressive Web App with service worker |
| `use_analytics` | ✓ | Microsoft Clarity analytics integration |
| `use_git_hooks` | ✓ | Pre-commit hooks for code quality |
| `git_hook_tool` | `detect-secrets` | Secret scanning tool |

### Project Structure

| Option | Default | Description |
|--------|---------|-------------|
| `scaffold_components` | All | Multiselect: api, auth, components, pages, lib, types, hooks |
| `include_docker` | ✓ | Generate Dockerfile and docker-compose.yml |
| `include_makefile` | ✓ | Makefile with common commands |
| `include_setup_script` | ✓ | Interactive setup script |

### Python Tooling (for Git Hooks)

| Option | Default | Description |
|--------|---------|-------------|
| `python_version` | `3.13` | Python version for git hooks |
| `python_dependency_manager` | `uv` | uv, pip, poetry, or pipenv |

## 🛠️ Useful Commands

### Development

```bash
# Start dev server with HMR
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run linting
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format

# Check formatting
npm run format:check

# Type check
npm run typecheck
```

### Testing

```bash
# Run unit tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with UI
npm run test:ui

# Generate coverage report
npm run test:coverage
```

### Docker

```bash
# Build Docker image
npm run docker:build
# or
docker build -t my-app:latest .

# Run with Docker Compose
npm run docker:up
# or
docker compose up --build

# Stop services
npm run docker:down
# or
docker compose down

# View logs
docker compose logs -f

# Shell into container
docker compose exec frontend sh
```

### Makefile (if included)

If you enabled the Makefile option, you can use convenient shortcuts:

```bash
# Development
make dev           # Start dev server (npm run dev)
make install       # Install dependencies

# Build and Test
make build         # Build for production
make test          # Run tests
make lint          # Run linting
make format        # Format code

# Docker
make docker-build  # Build Docker image
make docker-up     # Start containers
make docker-down   # Stop containers
make docker-logs   # View logs
make docker-shell  # Shell into frontend container

# Cleanup
make clean         # Clean build artifacts
make clean-all     # Clean everything including node_modules
```

### Git Hooks

```bash
# Install pre-commit hooks (if enabled)
pre-commit install

# Run hooks manually
pre-commit run --all-files

# Update hooks
pre-commit autoupdate
```

## 📁 Generated Project Structure

```
my-new-app/
├── .cursor/                    # Cursor AI rules
│   └── rules/
│       ├── general.mdc        # General coding guidelines
│       ├── project.mdc        # Project-specific context
│       ├── react.mdc          # React best practices
│       └── tools.mdc          # Development tools guide
├── src/                        # Source code
│   ├── api/                   # API clients
│   ├── auth/                  # Authentication (MSAL)
│   ├── components/            # React components
│   ├── pages/                 # Page components
│   ├── lib/                   # Utilities
│   ├── types/                 # TypeScript types
│   ├── hooks/                 # Custom React hooks
│   ├── App.tsx                # Main app component
│   └── main.tsx               # Entry point
├── public/                     # Static assets
├── tests/                      # Test files
├── docker/                     # Docker support files
│   ├── entrypoint.sh          # Runtime env injection
│   └── nginx.conf             # Nginx configuration
├── Dockerfile                  # Multi-stage build
├── docker-compose.yml          # Service orchestration
├── .env.example               # Environment template
├── .gitignore                 # Git ignore rules
├── .dockerignore              # Docker ignore rules
├── .prettierrc                # Prettier config
├── eslint.config.js           # ESLint config
├── tsconfig.json              # TypeScript config
├── vite.config.ts             # Vite config
├── vitest.config.ts           # Vitest config
├── tailwind.config.js         # Tailwind config
├── package.json               # NPM dependencies
├── Makefile                   # Common commands
└── README.md                  # Project documentation
```

## 🔧 Configuration

### Environment Variables

The template uses runtime environment injection, allowing you to change configuration without rebuilding the Docker image.

**Development (`.env`):**
```bash
# API Configuration
VITE_APP_API_BASE_URL=http://localhost:8000
VITE_APP_API_TIMEOUT=30000

# Azure AD Authentication (if enabled)
VITE_APP_AZURE_CLIENT_ID=your-client-id
VITE_APP_AZURE_TENANT_ID=your-tenant-id
VITE_APP_AZURE_REDIRECT_URI=http://localhost:3000

# Microsoft Clarity (if enabled)
VITE_APP_CLARITY_PROJECT_ID=your-clarity-id

# Development Options
VITE_APP_DEV_NO_AUTH=false
VITE_APP_ENABLE_MOCK_API=false
```

**Production:**
Variables are injected at runtime in the Docker container. Update `.env` and restart the container - no rebuild needed!

### Azure AD Setup

If you enabled Azure Auth, configure your Azure AD app:

1. Register app in Azure Portal
2. Add redirect URIs (http://localhost:3000 and production URL)
3. Configure API permissions (User.Read minimum)
4. Update `.env` with client ID and tenant ID

See `README.md` in the generated project for detailed setup.

### Tailwind Configuration

Customize `tailwind.config.js`:
```javascript
export default {
  theme: {
    extend: {
      colors: {
        primary: '#your-color',
        secondary: '#your-color',
      },
    },
  },
}
```

## 🐳 Docker Deployment

### Local Development

```bash
# Build and run
docker compose up --build

# Run in background
docker compose up -d

# View logs
docker compose logs -f frontend

# Stop services
docker compose down
```

### Production Deployment

The template includes:
- Optimized multi-stage Dockerfile
- Nginx configuration for SPAs
- Health check endpoints
- Runtime environment injection

Deploy to:
- **Azure Container Apps**
- **Azure Container Instances**
- **Azure App Service** (containers)
- **AWS ECS/Fargate**
- **Google Cloud Run**
- **Kubernetes**

## 🧪 Testing

### Unit Tests (Vitest)

```bash
# Run once
npm test

# Watch mode
npm run test:watch

# Coverage
npm run test:coverage
```

## 📚 Documentation

Generated projects include comprehensive documentation:

- **README.md** - Project overview and setup
- **DOCKER_QUICK_START.md** - Docker usage guide (if enabled)
- **.cursor/rules/** - AI assistant coding guidelines
- **API documentation** - Inline with source code

## 🤝 Contributing to Template

To improve this template:

1. Fork the repository
2. Create a feature branch
3. Test with `copier copy . /tmp/test-project`
4. Submit a pull request

### Testing Template Changes

```bash
# Test locally
uvx copier copy . /tmp/test-project --trust

# Test with defaults
uvx copier copy . /tmp/test-project --defaults --trust

# Skip post-generation tasks
uvx copier copy . /tmp/test-project --defaults --trust --skip-tasks

# Update existing project
uvx copier update /path/to/existing-project --trust
```

## 🔍 Troubleshooting

### Copier Issues

**Error: "Template uses potentially unsafe features"**
```bash
# Add --trust flag
uvx copier copy . /tmp/test --trust
```

**Error: "No module named 'jinja2_time'"**
- Remove `jinja2_time` from `_jinja_extensions` in `copier.yml`

### Generated Project Issues

**Port already in use:**
```bash
# Change port in vite.config.ts or use different port
npm run dev -- --port 3001
```

**Docker build fails:**
```bash
# Clear Docker cache
docker builder prune -a
docker compose build --no-cache
```

**Type errors:**
```bash
# Regenerate types
npm run typecheck
```

## 📄 License

MIT License - see LICENSE file for details

## 🙋 Support

- **Issues**: Report bugs or request features via GitHub Issues
- **Discussions**: Ask questions in GitHub Discussions
- **Documentation**: Check generated project README.md

## 🎉 Credits

Built with:
- [Copier](https://copier.readthedocs.io/) - Template engine
- [React](https://react.dev/) - UI library
- [Vite](https://vitejs.dev/) - Build tool
- [TypeScript](https://www.typescriptlang.org/) - Type safety
- [Tailwind CSS](https://tailwindcss.com/) - Styling
- [Docker](https://www.docker.com/) - Containerization

---

**Ready to build something amazing?** 🚀

```bash
uvx copier copy gh:Alkeme-Insurance/alkeme-template-frontend my-new-app
cd my-new-app
npm install
npm run dev
```

