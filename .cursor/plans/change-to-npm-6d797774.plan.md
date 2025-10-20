<!-- 6d797774-b2e4-42b6-a886-3a3bcd2248d1 e4d41277-2e6a-4f35-bc0c-d6039cc58151 -->
# Integrate ALKEME Marketing Assets and Cleanup

## 1. Replace Logo Files with Professional Assets

Replace placeholder SVGs in `template/public/` with professional vector logos:

**Primary Logo Files:**

- Copy `Vector/Vector/ALKEME_Logo_Color.svg` → `template/public/alkeme-logo.svg` (replaces placeholder)
- Copy `Vector/Vector/ALKEME_Logo_All-White.svg` → `template/public/alkeme-logo-white.svg` (replaces placeholder)
- Copy `Vector/Vector/ALKEME_Logo_All-Black.svg` → `template/public/alkeme-logo-black.svg` (new)
- Copy `Vector/Vector/ALKEME_Logo_INS.svg` → `template/public/alkeme-logo-horizontal.svg` (replaces placeholder, likely has full branding)

**Icon/Avatar:**

- Use `Avatar/Avatar/ALKEME-avatar_transparent.png` as base for icon
- Keep `Avatar/Avatar/ALKEME-avatar_Ybg.png` as alternative

## 2. Generate Favicon Set from Avatar

Using `Avatar/Avatar/ALKEME-avatar_transparent.png`:

- Create `template/public/favicon.svg` (convert/optimize PNG to SVG if possible, or use optimized PNG)
- Create `template/public/favicon-16x16.png`
- Create `template/public/favicon-32x32.png`
- Create `template/public/favicon-192x192.png` (for PWA)
- Create `template/public/favicon-512x512.png` (for PWA)
- Create `template/public/apple-touch-icon.png` (180x180)

## 3. Update Logo Component

Update `template/src/app/components/Logo.tsx`:

- Add 'black' variant option
- Update logoSrc mapping to include black variant
- Keep existing size and className props
```tsx
const logoSrc = {
  primary: '/alkeme-logo.svg',
  white: '/alkeme-logo-white.svg',
  black: '/alkeme-logo-black.svg',
  icon: '/alkeme-logo-icon.svg',
  horizontal: '/alkeme-logo-horizontal.svg'
}
```


## 4. Update site.webmanifest

Update `template/public/site.webmanifest.jinja` with correct PNG icon paths:

- Reference new favicon-192x192.png
- Reference new favicon-512x512.png
- Keep ALKEME branding and theme colors

## 5. Update Logo Usage Documentation

Update `template/docs/LOGO_USAGE.md`:

- Document the professional logo files (noting they are from marketing)
- Add black logo variant usage guidelines
- Update size recommendations based on actual professional logo dimensions
- Add note about avatar/icon being official brand asset

## 6. Organize Brand Assets

Create `template/docs/brand-assets/` directory structure:

- Move `ALKEME-BrandGuidelines_04102024 (1).pdf` → `template/docs/brand-assets/`
- Move `ALKEME Social Media, Public Relations, and Media Guidelines.pdf` → `template/docs/brand-assets/`
- Copy `Avatar/Avatar/alkeme-arrow.pdf` → `template/docs/brand-assets/`

## 7. Cleanup Temporary Files

**Delete from root:**

- `ALKEME_Logo_Color.png`
- `OneDrive_1_10-20-2025.zip`
- `Avatar.zip`
- `Vector.zip`
- All `*.Zone.Identifier` files in `OneDrive_1_10-20-2025/`, `Avatar/Avatar/`, and `Vector/Vector/`

**Delete extracted directories after copying assets:**

- `OneDrive_1_10-20-2025/` (contains only AI files, not needed for web)
- `Avatar/` (after copying PNG files)
- `Vector/` (after copying SVG files)

## 8. Update README

Update `README.md` branding assets section:

- Note that logos are official ALKEME marketing assets
- Update logo file list to include black variant
- Add reference to brand guidelines in `docs/brand-assets/`
- Update favicon description to reference avatar asset

## 9. Test Generated Template

Generate a test project to verify:

- All logo files copy correctly
- Favicon files are present and valid
- Logo component works with all variants
- Build completes successfully
- No broken image references

### To-dos

- [ ] Copy professional Vector SVG logos to template/public/
- [ ] Generate favicon set from avatar PNG using image conversion
- [ ] Add black variant to Logo component
- [ ] Update site.webmanifest with correct PNG paths
- [ ] Update LOGO_USAGE.md with professional assets info
- [ ] Move brand guideline PDFs to docs/brand-assets/
- [ ] Delete zip files, Zone.Identifier files, and extracted directories
- [ ] Update README branding section with official asset info
- [ ] Generate and verify test project builds correctly