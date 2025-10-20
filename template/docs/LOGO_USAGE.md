# ALKEME Logo Usage Guide

## Available Logo Files

The template includes official ALKEME marketing assets from the brand guidelines.

### Primary Logos (Professional Marketing Assets)

- **`alkeme-logo.svg`** - Full color logo with ALKEME text and growth arrow
  - Use on light/white backgrounds
  - Primary brand representation
  - Official marketing asset (ALKEME_Logo_Color.svg)
  - Dimensions: 1000x350px (viewbox)

- **`alkeme-logo-white.svg`** - All-white version
  - Use on dark or colored backgrounds
  - Maintains brand visibility
  - Official marketing asset (ALKEME_Logo_All-White.svg)
  - Dimensions: 1000x350px (viewbox)

- **`alkeme-logo-black.svg`** - All-black version
  - Use on light backgrounds where color is not appropriate
  - Suitable for print or monochrome applications
  - Official marketing asset (ALKEME_Logo_All-Black.svg)
  - Dimensions: 1000x350px (viewbox)

- **`alkeme-logo-horizontal.svg`** - Full branding with tagline
  - Use in wide header spaces
  - Includes complete brand messaging
  - Official marketing asset (ALKEME_Logo_INS.svg)
  - Dimensions: 1000x350px (viewbox)

- **`alkeme-logo-icon.png`** - Official ALKEME avatar (transparent)
  - Use in small spaces (nav, mobile menus, favicons)
  - Square format for app icons
  - Official marketing asset from Avatar collection
  - Available in multiple background variants

- **`intelligent-solutions-logo.png`** - Intelligent Solutions division logo
  - Use for division-specific branding
  - Complements main ALKEME branding
  - Available in PNG format
  - Use when highlighting Intelligent Solutions division

### Banners

- **`banners/hero-banner.svg`** - Hero banner with full branding
  - Use on landing pages and marketing materials
  - Includes logo, tagline, and brand message
  - Dimensions: 1200x400px (viewbox)

## Logo Component

Use the React Logo component for consistency:

```tsx
import { Logo } from '@/app/components/Logo'

// Primary logo (default)
<Logo />

// White logo for dark backgrounds
<Logo variant="white" />

// Black logo for light backgrounds (monochrome)
<Logo variant="black" />

// Icon only
<Logo variant="icon" />

// Horizontal with tagline
<Logo variant="horizontal" />

// Intelligent Solutions division logo
<Logo variant="division" />

// Different sizes
<Logo size="sm" />  // h-8 (32px)
<Logo size="md" />  // h-12 (48px) - default
<Logo size="lg" />  // h-16 (64px)
<Logo size="xl" />  // h-24 (96px)

// Custom styling
<Logo className="opacity-80 hover:opacity-100" />
```

## Direct Image Usage

If you can't use the component:

```tsx
<img 
  src="/alkeme-logo.svg" 
  alt="ALKEME Insurance" 
  className="h-12 w-auto"
/>
```

## Size Guidelines

### Minimum Sizes

To maintain legibility and brand integrity (per official brand guidelines):

- **Full logo**: Minimum height 48px (web), 0.6" (print)
- **Icon/Avatar**: Minimum 32px square (web), 0.35" (print)
- **Text legibility**: Ensure arrow symbol remains visible

### Recommended Sizes

- **Header**: 48-72px height (professional logos scale well)
- **Hero section**: 96-144px height
- **Footer**: 40-48px height
- **Mobile header**: 48-56px height
- **Favicon**: Use favicon.png or favicon-*.png variants

## Clear Space

Maintain adequate space around the logo for visual impact:

- **Minimum clear space**: Equal to the height of the growth arrow symbol
- No other logos, text, or graphics should infringe on this space
- Applies to all sides of the logo

Example:
```
┌─────────────────────────────────────┐
│                                     │
│         (clear space)               │
│                                     │
│    ┌────────────────┐               │
│    │  ALKEME LOGO   │               │
│    └────────────────┘               │
│                                     │
│         (clear space)               │
│                                     │
└─────────────────────────────────────┘
```

## Color Usage

### Primary Colors

- **ALKEME Yellow**: #FFBF3C (RGB: 255, 191, 60)
- **Black**: #000000 (RGB: 0, 0, 0)

### On Light Backgrounds

Use the primary logo (`alkeme-logo.svg`):
- Full color with yellow background and black text
- Ensures maximum visibility and brand recognition

### On Dark Backgrounds

Use the white logo (`alkeme-logo-white.svg`):
- White text with yellow accent underline
- Maintains brand identity in dark themes

### Background Requirements

- **Light backgrounds**: Use primary logo
  - White, light gray, light blue, etc.
  - Ensure sufficient contrast

- **Dark backgrounds**: Use white logo
  - Navy, black, dark gray, dark blue, etc.
  - Yellow accent provides brand recognition

## What NOT to Do

### ❌ Incorrect Usage

1. **Don't stretch or distort**
   ```tsx
   // BAD - distorts proportions
   <img src="/alkeme-logo.svg" style={{ width: '100%', height: '20px' }} />
   
   // GOOD - maintains aspect ratio
   <img src="/alkeme-logo.svg" className="h-12 w-auto" />
   ```

2. **Don't rotate**
   - Never rotate the logo at any angle
   - Always keep horizontal

3. **Don't change colors**
   - Use provided logo variations only
   - Don't recolor the logo elements

4. **Don't add effects**
   - No drop shadows, gradients, or filters
   - Keep the logo clean and crisp

5. **Don't place on busy backgrounds**
   - Ensure sufficient contrast
   - Use solid or subtle gradient backgrounds

6. **Don't recreate the logo**
   - Always use provided SVG/PNG files
   - Don't attempt to recreate with text and shapes

## Accessibility

- Always include descriptive `alt` text: "ALKEME Insurance"
- Use semantic HTML (`<img>` with alt, not background images)
- Ensure logo has sufficient color contrast with background
- Logo component includes `loading="lazy"` for performance

## File Formats

### SVG (Recommended)
- Vector format, scales to any size
- Small file size
- Best for web and digital use
- Use for responsive designs

### PNG (Provided for compatibility)
- Raster format for legacy systems
- Multiple sizes available
- Use when SVG not supported

## Examples

### Header Navigation
```tsx
<header className="bg-white shadow">
  <div className="container mx-auto px-4 py-4">
    <Logo size="md" />
  </div>
</header>
```

### Login Page
```tsx
<div className="text-center">
  <Logo size="lg" className="mx-auto mb-6" />
  <h1>Sign In</h1>
</div>
```

### Footer
```tsx
<footer className="bg-gray-900 text-white">
  <div className="container mx-auto px-4 py-8">
    <Logo variant="white" size="sm" />
  </div>
</footer>
```

### Mobile Navigation
```tsx
<nav className="md:hidden">
  <Logo variant="icon" size="sm" />
</nav>
```

### Division Branding
```tsx
<div className="division-section">
  <Logo variant="division" size="md" />
  <h2>Intelligent Solutions</h2>
</div>
```

## Brand Colors Reference

Use these colors throughout your application:

```tsx
// Tailwind config includes:
colors: {
  alkeme: {
    yellow: '#FFBF3C',
    black: '#000000',
    blue: '#5387AC',
    'light-blue': '#91CBEF',
    gray: '#5F6060',
    'light-gray': '#F0F3F5',
  }
}
```

## Brand Guidelines Reference

For complete brand guidelines and usage instructions, see:
- `docs/brand-assets/ALKEME-BrandGuidelines_04102024.pdf` - Complete brand guidelines
- `docs/brand-assets/ALKEME Social Media, Public Relations, and Media Guidelines.pdf` - Social media usage
- `docs/brand-assets/alkeme-arrow.pdf` - Arrow symbol specifications

## Source Assets

All logo files are official ALKEME marketing assets:
- Vector logos: Professional SVG files from marketing team
- Avatar/Icon: Official ALKEME avatar in multiple formats
- Favicons: Generated from official avatar assets

## Questions?

For logo files in other formats or sizes, or if you have questions about logo usage, please contact the ALKEME brand team.

---

**Last Updated**: October 2024
**ALKEME Insurance** - Shaping the future of insurance. One partner at a time.

