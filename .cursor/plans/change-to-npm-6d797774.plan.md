<!-- 6d797774-b2e4-42b6-a886-3a3bcd2248d1 fcd9ae32-b03f-4b93-a2dc-b0a44a7af1e3 -->
# Fix Template to Generate Runnable Application

## Issues to Fix

Based on the test results, there are 2 TypeScript errors preventing the template from building:

1. **src/app/pages/HomePage.tsx** - Unused `Link` import from react-router-dom
2. **src/test/setup.ts** - Test setup configuration issue (line 6)

## Changes Required

### 1. Fix HomePage.tsx

**File:** `template/src/app/pages/HomePage.tsx.jinja` (or similar)

Either:
- Remove the unused `Link` import, OR
- Use the `Link` component in the HomePage

### 2. Fix test/setup.ts

**File:** `template/src/test/setup.ts.jinja` (or similar)

Fix the vitest setup configuration - likely an issue with how `@testing-library/jest-dom` is being imported or called.

### 3. Test the Fixed Template

After fixes:
1. Generate a new test project
2. Run `npm run build` - should succeed
3. Run `npm run typecheck` - should succeed
4. Run `npm test` - should work (even if no tests yet)
5. Optionally start dev server to verify it runs

## Expected Result

After these fixes, the generated template should:
- ✅ Build without TypeScript errors
- ✅ Pass type checking
- ✅ Have a working dev server
- ✅ Be immediately usable by developers