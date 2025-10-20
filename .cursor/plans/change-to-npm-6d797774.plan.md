<!-- 6d797774-b2e4-42b6-a886-3a3bcd2248d1 8559c7f5-6f46-49a7-bda6-7b5f806142a0 -->
# Simplify to npm Only

## Changes Required

### 1. Update copier.yml

**Line 273-276** - Remove package_manager variable entirely:

- Delete the entire `package_manager` section (no longer needed)

**Lines 299-311** - Remove Corepack and simplify install:

```yaml
# Install dependencies
- command: npm install
```

**Lines 361-373** - Hard-code npm commands in success message:

```yaml
echo "  2. npm run dev       # Start development server"
echo "  3. npm test          # Run tests"
echo "  4. npm run docker:up # Run with Docker"
```

### 2. Update template/package.json.jinja

**Line 76** - Hard-code npm engine requirement:

```json
"npm": ">=9.0.0"
```

**Line 78** - Hard-code npm package manager:

```json
"packageManager": "npm@10.9.0"
```

### 3. Update template/Dockerfile and template/Dockerfile.jinja

**Lines 9-11** - Remove Corepack:

- Delete the Corepack enable lines

**Line 13** - Simplify to npm only:

```dockerfile
COPY package.json package-lock.json* ./
```

**Lines 16-18** - Hard-code npm install:

```dockerfile
RUN npm ci --prefer-offline || npm install
```

**Lines 30-32** - Hard-code npm build:

```dockerfile
RUN npm run build
```

### 4. Update template/Makefile.jinja

**Line 64** - Simplify clean target:

```makefile
rm -rf node_modules package-lock.json
```

### 5. Update README.md

**Line 36** - Remove package manager mention or simplify:

- "- **npm** - Node.js package manager"

**Line 75** - Remove package manager choice:

- Remove this line entirely (no longer a choice)

**Line 84** - Simplify install command:

```bash
npm install
```

**Lines 100, 116, 150-204, 221** - Use npm commands:

```bash
npm run dev
npm run build
npm run preview
npm run lint
npm run lint:fix
npm run format
npm run format:check
npm run typecheck
npm test
npm run test:watch
npm run test:ui
npm run test:coverage
npm run docker:build
npm run docker:up
npm run docker:down
```

**Line 221** - Update Makefile description:

```bash
make dev           # Start dev server (npm run dev)
```

### 6. Update Documentation Files

**PROGRESS_REPORT.md** (line 73):

- Change to "✅ Uses npm for package management"

**DOCKER_FILES_SUMMARY.md** (line 34):

- Change to "✅ Uses npm for package management"

**REACT_SOURCE_CODE_SUMMARY.md:**

- Line 355: `npm install`
- Line 361: `npm run dev`
- Line 369: `npm run build`
- Line 372: `npm run preview`
- Line 416: `npm run dev`

**project-spec.md:**

- Line 40: "Post-generation tasks: git init, npm install, initial commit"
- Line 208: "Install dependencies with npm"
- Line 439: "Setup Node.js (LTS, npm cache)"

**Project.md:**

- Line 69: Change to just `npm install`
- Lines 111-115: Simplify Dockerfile example to npm only
- Lines 421-426: Update GitHub Actions to use npm only

### 7. Remove package manager references in copier.yml

Search for any remaining pnpm/yarn/package_manager references and remove:

- Template metadata section (lines 422-436)
- Any documentation comments mentioning multiple package managers

### 8. Verify Vite Configuration

No changes needed - Vite is already properly configured:

- `template/vite.config.ts.jinja` exists and is configured
- `package.json.jinja` scripts use Vite commands
- Dev server runs on port 5173

## Result

After these changes:

- Only npm is supported (no conditional logic)
- Simpler, cleaner template code
- Vite remains as the build tool (already configured)
- Faster template generation (fewer decisions)
- Reduced maintenance burden (one package manager to support)