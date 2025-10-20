<!-- 6d797774-b2e4-42b6-a886-3a3bcd2248d1 5f02c9d5-9f80-4ddb-982f-2e6deefcd049 -->
# Enhanced Template README and Division Logo

## 1. Add Intelligent Solutions Division Logo

Copy division logo to template and update documentation:
- Copy `intelligent_solutions_logo.png` → `template/public/intelligent-solutions-logo.png`
- Update `Logo.tsx` component to support division logo variant
- Add division logo to logo usage documentation
- Delete `intelligent_solutions_logo.png` from root after copying

## 2. Create Comprehensive Template README

Create `template/README.md.jinja` with:

### Header Section
- Project name with ALKEME branding
- One-line description: "ALKEME Insurance Platform - Full-service insurance agency providing innovative solutions"
- Badges (optional): Build status, License, Node version

### Quick Start Section
```markdown
## Quick Start

### Prerequisites
- Node.js 20+ and npm 9+
- Git

### Installation
```bash
# Install dependencies
npm install

# Copy environment file
cp env.example .env

# Update .env with your Azure AD credentials (if using authentication)
```

### Development
```bash
# Start development server (http://localhost:5173)
npm run dev
```

### Build
```bash
# Create production build
npm run build

# Preview production build
npm run preview
```

### Docker (Alternative)
```bash
# Using npm scripts
npm run docker:up    # Start
npm run docker:down  # Stop

# Or using make
make up    # Start
make down  # Stop
make logs  # View logs
```
```

### Project Description
- Brief overview of what the platform provides
- Key capabilities (authentication, responsive UI, production-ready)
- ALKEME Insurance context

### Tech Stack
- **Frontend**: React 18, TypeScript, Vite
- **Styling**: Tailwind CSS, shadcn/ui components
- **Authentication**: {% if use_azure_auth %}Azure AD (MSAL.js){% else %}Ready for auth integration{% endif %}
- **State Management**: React hooks, Context API
- **Build Tool**: Vite with Hot Module Replacement
- **Testing**: Vitest, React Testing Library
- **Deployment**: Docker, Azure Container Apps

### Project Structure
```
{{ package_name }}/
├── src/
│   ├── app/              # Application components
│   │   ├── components/   # Reusable UI components
│   │   └── pages/        # Page components
│   ├── api/              # API client utilities
│   ├── auth/             # Authentication configuration
│   ├── lib/              # Utility functions
│   └── styles/           # Global styles
├── public/               # Static assets
├── docs/                 # Documentation
├── infra/                # Azure infrastructure (Bicep)
└── docker/               # Docker configuration
```

### Available Commands
Table of all npm scripts:
- `npm run dev` - Development server
- `npm run build` - Production build
- `npm run preview` - Preview production build
- `npm test` - Run tests
- `npm run typecheck` - TypeScript checking
- `npm run lint` - Lint code
- `npm run format` - Format code

### Environment Configuration
- List key environment variables
- Point to `env.example`
- Note Azure AD configuration if enabled

### Azure Deployment
- Link to `infra/README.md`
- Quick deployment steps
- Prerequisites

### Key Features
- ✓ Official ALKEME branding and logos
- ✓ {% if use_azure_auth %}Azure AD authentication{% endif %}
- ✓ Responsive design (mobile-first)
- ✓ Type-safe development (TypeScript)
- ✓ Production-ready Docker setup
- ✓ CI/CD with GitHub Actions
- ✓ Pre-commit hooks for code quality

### Documentation
- Link to `docs/LOGO_USAGE.md`
- Link to brand guidelines
- Link to Azure setup guide

### License
- MIT or appropriate license

## 3. Update Logo Component for Division Logo

Add division logo variant to `Logo.tsx`:
```tsx
interface LogoProps {
  variant?: 'primary' | 'white' | 'black' | 'icon' | 'horizontal' | 'division'
  // ...
}

const logoSrc = {
  // ... existing
  division: '/intelligent-solutions-logo.png'
}
```

## 4. Update Logo Usage Documentation

Add division logo section to `LOGO_USAGE.md`:
- **`intelligent-solutions-logo.png`** - Intelligent Solutions division logo
  - Use for division-specific branding
  - Complements main ALKEME branding
  - Available in PNG format

## 5. Cleanup

Delete from root:
- `intelligent_solutions_logo.png`

## 6. Test Generated Project

Verify:
- Template generates with complete README
- Quick start commands work as documented
- Division logo is present and accessible
- README is clear and actionable for new developers

### To-dos

- [ ] Copy intelligent_solutions_logo.png to template/public/
- [ ] Create comprehensive template/README.md.jinja with quick start and overview
- [ ] Add division variant to Logo component
- [ ] Add division logo to LOGO_USAGE.md
- [ ] Delete intelligent_solutions_logo.png from root
- [ ] Generate test project and verify README is complete and accurate