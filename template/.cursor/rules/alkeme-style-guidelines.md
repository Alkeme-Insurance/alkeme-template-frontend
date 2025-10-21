# ALKEME Brand Style Guidelines

This rule ensures consistent application of ALKEME Insurance brand standards across all client-facing code, UI components, and content.

## When This Rule Applies

**STRICT ENFORCEMENT** for:
- Customer-facing interfaces and pages
- Marketing pages and landing pages
- Public documentation
- Email templates
- User-visible components and text
- Social media content
- Any public-facing communication

**MORE FLEXIBILITY** for:
- Internal admin tools
- Development documentation
- Backend code comments
- Non-customer-facing utilities

## Brand Identity

### Official Name
- Always write as: **ALKEME** (all uppercase letters)
- Never: Alkeme, alkeme, or AlKeme
- Single word, no spaces

### Tagline
```
Insurance everything.
```
- Use standalone, not locked up with logo
- Lowercase except first letter
- Always ends with period

### Lead Message
```
Shaping the future of insurance. One partner at a time.
```

### Corporate Boilerplate
ALKEME is a full-service insurance agency providing businesses and individuals with an extensive array of commercial and personal insurance, employee and executive benefits, retirement and wealth management services. Since its founding in 2020, ALKEME has completed over 40 acquisitions and serves its customers from over 35 locations in 16 states. ALKEME is ranked by Insurance Journal as one of the top 40 largest agencies in the United States and by Business Insurance as the #5 fastest growing broker. Founded by owner/operators with a unique vision, ALKEME is fueled by its proven operating methodologies providing its partner agencies with the autonomy, resources and support to grow and thrive in an ever-changing insurance landscape.

## Brand Attributes

When designing or writing, embody these core attributes:

### Innovative
- We are changing how insurance companies operate, market, grow and succeed
- Be clear in explaining what ALKEME does
- Share ideas and experiences about what we do and how we do it
- Show enthusiasm
- Show use cases and partner examples

### Authentic
- We know where we came from and everyone trusts us
- Write conversationally
- Be friendly, not phony
- Use words everyone understands
- Use humor appropriately

### Creative
- Look at things differently
- Take unique approaches to solving problems
- Talk about new ideas
- Be unique in communication
- Find new ways to communicate mundane topics
- Keep readers engaged

### Adaptable
- Constantly moving forward
- Adapting to new market opportunities
- Not afraid to make changes
- Push a "can-do" attitude
- Show potential for doing things differently
- Converse, don't tell
- Be emotional and real

## Voice and Tone

### Voice Guidelines
Think and talk like a human. Core principles:

- **Innovative but not out of touch**
- **Conversational but still professional**
- **Honest but not aggressive**
- **Helpful but not overbearing**
- **Fun but not silly**
- **Informal but not sloppy**

### Writing Standards

**Sentence Length**
- Maximum 25 words per sentence
- Short and punchy

**Paragraph Length**
- Maximum 4-5 sentences
- Keep paragraphs short and to the point

**Language**
- Minimize insurance jargon and acronyms
- Use plain English
- Be conversational
- Get to the point quickly

**What to Avoid**
- Do NOT use subjective enthusiasm: "great idea!", "amazing!", "awesome!"
- Do NOT use congratulatory language: "good job", "excellent work"
- Do NOT use generalizations: "meticulously improved", "in great shape"
- Do NOT be phony or overly enthusiastic
- Do NOT use aggressive or overbearing language

**What to Do**
- Be clear and factual
- Use specific descriptions
- Show, don't tell
- Use humor when appropriate
- Write succinctly
- Be friendly and genuine

## Typography

### Primary Typeface: Poppins
- Default weight: Regular (400)
- Available weights: Light (300), Regular (400), Medium (500), SemiBold (600), Bold (700), Black (900)
- Use for headings, body copy, UI elements
- Download free from Google Fonts

### Secondary Typeface: Open Sans
- Use when Poppins is not available
- For presentations, web, documents
- Considered a safe fallback font
- Weights: Light, Regular, Semibold, Extrabold

### Usage in Code
```typescript
// Tailwind config
fontFamily: {
  sans: ['Poppins', 'Open Sans', 'sans-serif'],
}

// CSS
font-family: 'Poppins', 'Open Sans', sans-serif;
```

### Font Weight Guidelines
- **Light (300)**: Supporting copy, de-emphasized text
- **Regular (400)**: Body text, paragraphs
- **Medium (500)**: Slightly emphasized text
- **SemiBold (600)**: Subheadings, buttons
- **Bold (700)**: Headings, important callouts
- **Black (900)**: Large headlines, hero text

## Brand Colors

### Primary Colors

**ALKEME Yellow** (Primary Brand Color)
- Hex: `#FFBF3C`
- RGB: 255, 191, 60
- CMYK: 0, 27, 87, 0
- PANTONE: 136C
- Use for: Primary actions, accents, brand emphasis

**Black**
- Hex: `#000000`
- RGB: 0, 0, 0
- CMYK: 0, 0, 0, 100
- Use for: Text, logo, high contrast elements

### Secondary Colors

**Blue**
- Hex: `#5387AC`
- RGB: 83, 135, 172
- CMYK: 71, 31, 19, 1
- Use for: Separation, emphasis, supporting content

**Light Blue**
- Hex: `#91CBEF`
- RGB: 145, 203, 239
- CMYK: 40, 6, 0, 0
- Use for: Backgrounds, accents, highlights

**Gray**
- Hex: `#5F6060`
- RGB: 95, 96, 96
- CMYK: 62, 53, 53, 24
- Use for: Supporting text, borders

**Light Gray**
- Hex: `#F0F3F5`
- RGB: 240, 243, 245
- CMYK: 5, 2, 2, 0
- Use for: Backgrounds, subtle separation

### Tailwind Configuration
```javascript
colors: {
  alkeme: {
    yellow: '#FFBF3C',      // Primary
    black: '#000000',
    blue: '#5387AC',
    'light-blue': '#91CBEF',
    gray: '#5F6060',
    'light-gray': '#F0F3F5',
  },
  primary: {
    DEFAULT: '#FFBF3C',     // Map to ALKEME yellow
  }
}
```

## Logo Usage

### Available Logo Variants

**Color Usage**
- `alkeme-logo.svg` - Full color (primary for light backgrounds)
- `alkeme-logo-white.svg` - All white (for dark backgrounds)
- `alkeme-logo-black.svg` - All black (for monochrome/print)
- `alkeme-logo-horizontal.svg` - Full branding with tagline
- `alkeme-logo-icon.png` - Avatar icon (transparent)
- `intelligent-solutions-logo.png` - Division branding

### Logo Component Usage
```tsx
import { Logo } from '@/app/components/Logo'

// Primary logo (default)
<Logo />

// Variants
<Logo variant="white" />       // Dark backgrounds
<Logo variant="black" />       // Monochrome/print
<Logo variant="icon" />        // Avatar icon
<Logo variant="horizontal" />  // With tagline
<Logo variant="division" />    // Intelligent Solutions

// Sizes
<Logo size="sm" />  // h-8 (32px)
<Logo size="md" />  // h-12 (48px) - default
<Logo size="lg" />  // h-16 (64px)
<Logo size="xl" />  // h-24 (96px)
```

### Clear Space
- Maintain buffer space around logo equal to the height of the ALKEME arrow
- No other logos, type, or graphic elements should infringe
- Keep area around logo completely clear

### Minimum Size
- Print: 1.5 inches width minimum
- Digital: 110 pixels width minimum

### Incorrect Usage
- Do NOT outline the logo
- Do NOT rotate the logo
- Do NOT stretch, modify, or distort the logo
- Do NOT change the colors of the logo
- Do NOT use the bug and full logo together

## Content Rules

### Spelling and Capitalization
- ALKEME: Always all uppercase
- Insurance everything.: Tagline format
- Intelligent Solutions: Division name (title case)

### Writing Style
- Be concise and direct
- State answers without extra commentary
- Use descriptive, specific language
- Avoid superlatives unless backed by data
- No emojis in professional content (unless specifically appropriate)

### Headings and Structure
- Use clean, simple headings
- Do NOT use decorative headings like "===== SECTION ====="
- Do NOT number steps in UI copy (hard to maintain)
- Do NOT use special Unicode characters (•, –, —) in comments

### Comments in Code
When writing comments for customer-facing features:
- Keep concise and production-ready
- Explain intent, not obvious code
- Do NOT reflect what you did: "Added this function"
- Do NOT use emojis or special characters

## UI Design Standards

### Layout and Spacing
- Use consistent spacing based on 4px or 8px grid
- Maintain clear visual hierarchy
- Generous whitespace for clarity
- Balance text and visual elements

### Buttons and CTAs
- Primary actions: ALKEME yellow background
- Secondary actions: Outline or subtle background
- Text: Clear, action-oriented language
- Use SemiBold or Bold font weight

### Forms and Inputs
- Clear labels and helpful placeholder text
- Validation messages in plain language
- Error states in red, success in green
- Match ALKEME voice in all messages

### Color Contrast
- Ensure WCAG AA compliance minimum
- Test yellow (#FFBF3C) on light backgrounds
- Use sufficient contrast for readability
- Test with accessibility tools

### Responsive Design
- Mobile-first approach
- Touch-friendly tap targets (min 44x44px)
- Readable text sizes on all devices
- Test on multiple screen sizes

## AI Assistant Requirements

When creating client-facing UI, you MUST:

1. **Apply Brand Colors**: Use ALKEME color palette from Tailwind config
2. **Use Poppins Font**: Default to Poppins for all UI text
3. **Follow Voice Guidelines**: All user-visible text matches ALKEME tone
4. **Correct Capitalization**: Always write "ALKEME" in all caps
5. **Avoid Bad Patterns**: No subjective enthusiasm, no generic praise
6. **Maintain Consistency**: Use established component patterns
7. **Suggest Improvements**: If user request deviates from brand, suggest compliant alternative
8. **Protect Brand Integrity**: Push back politely if request would damage brand

### Example Corrections

**User Request**: "Add a button that says 'Click here for awesome insurance quotes!'"

**AI Response**: "I'll create a button, but let me adjust the copy to match ALKEME's voice. Instead of 'awesome', I suggest: 'Get Your Insurance Quote' - more direct and professional while staying friendly."

**User Request**: "Make the heading green"

**AI Response**: "ALKEME brand colors don't include green. I recommend using ALKEME yellow (#FFBF3C) for emphasis or blue (#5387AC) for supporting content. Which would work better here?"

## Reference Files

- Brand Guidelines: `docs/brand-assets/ALKEME-BrandGuidelines_04102024.pdf`
- Social Media Guidelines: `docs/brand-assets/ALKEME Social Media, Public Relations, and Media Guidelines.pdf`
- Logo Usage: `docs/LOGO_USAGE.md`

## Summary

When building client-facing features for ALKEME:
- Use official brand colors and Poppins typography
- Write in conversational, professional voice
- Keep it concise (max 25 words per sentence)
- Be innovative, authentic, creative, and adaptable
- Always write "ALKEME" in all caps
- Suggest brand-compliant alternatives when needed
- Maintain visual and verbal consistency

