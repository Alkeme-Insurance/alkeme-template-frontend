<!-- 6d797774-b2e4-42b6-a886-3a3bcd2248d1 410ee55e-f543-42df-9971-7461feed8510 -->
# Add ALKEME Style Guidelines to Cursor Rules

## Overview

Create `.cursor/rules/alkeme-style-guidelines.md` to encode ALKEME Insurance brand standards for AI-assisted development, with active enforcement for all client-facing UI design.

## Content to Include

### 1. Brand Identity

- Official name: ALKEME (all caps)
- Tagline: "Insurance everything."
- Lead message: "Shaping the future of insurance. One partner at a time."
- Boilerplate description from brand guidelines

### 2. Brand Attributes

- Innovative
- Authentic
- Creative
- Adaptable

### 3. Voice and Tone Guidelines

- Conversational but professional
- Honest but not aggressive
- Helpful but not overbearing
- Fun but not silly
- Informal but not sloppy
- Short sentences (max 25 words)
- Short paragraphs (4-5 sentences)
- Avoid insurance jargon
- Use humor appropriately

### 4. Typography

- Primary: Poppins (all weights)
- Secondary: Open Sans (fallback)
- Font weight usage guidelines

### 5. Brand Colors

- ALKEME Yellow: #FFBF3C (PANTONE 136C)
- Black: #000000
- Blue: #5387AC
- Light Blue: #91CBEF
- Gray: #5F6060
- Light Gray: #F0F3F5

### 6. Content Rules

- "ALKEME" always uppercase
- No subjective enthusiasm ("great", "amazing")
- Descriptive, specific language
- Clear space requirements for logos
- Minimum logo sizes

### 7. Code Implementation Guidelines

- Use brand colors in Tailwind config
- Logo component usage patterns
- Favor Poppins font in CSS
- Maintain brand consistency in UI text

## Critical UI Design Requirements

When creating any client-facing interface, the AI assistant MUST:

1. **Actively Apply Brand Guidelines**: All customer-facing UI components, pages, and text must follow ALKEME brand standards
2. **Proactive Suggestions**: Recommend brand-compliant alternatives when requests might deviate from guidelines
3. **Scope of Enforcement**:

- Customer-facing interfaces (strict adherence)
- Marketing pages (strict adherence)
- Public documentation (strict adherence)
- Email templates (strict adherence)
- User-visible components (strict adherence)
- Internal/admin tools (more flexibility allowed)

4. **Voice Compliance**: All user-visible text must match ALKEME voice and tone
5. **Visual Consistency**: Use approved colors, typography, and spacing standards
6. **Brand Integrity**: Protect brand reputation through consistent application

## File Location

`.cursor/rules/alkeme-style-guidelines.md`

## Implementation

Create new rule file with markdown formatting, organized into clear sections for easy reference by AI assistant during development. The rule should be structured to ensure active enforcement during UI creation tasks.

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