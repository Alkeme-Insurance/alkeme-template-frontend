<!-- 0c834ffb-1589-44ab-9e74-e03093e8b802 9c4f5822-a59e-4e49-b57a-27f5d2ee772d -->
# Automate Copier Configuration

## Overview

Update copier.yml to minimize user interaction by:

- Auto-populating author info from `gh api user`
- Auto-generating package_name from project_name
- Setting pnpm as default package manager
- Using production-ready defaults for feature flags
- Only keeping project_name as interactive prompt

## Changes to copier.yml

### 1. Add GitHub API User Detection (lines 8-17)

Add after `_envops` section:

```yaml
_jinja_extensions:
  - jinja2.ext.do

# Auto-detect user information from GitHub CLI
{% set gh_user = {} %}
{% if '{{ "which gh" | shell }}' %}
  {% set gh_user_json = '{{ "gh api user 2>/dev/null || echo {}" | shell }}' %}
  {% if gh_user_json %}
    {% set gh_user = gh_user_json | from_json %}
  {% endif %}
{% endif %}
```

### 2. Simplify Project Identity Section (lines 28-93)

**Keep as interactive:**

- `project_name` - User must provide this

**Remove these prompts** (make them computed/default):

- `package_name` - Auto-generate from project_name (already has default)
- `project_description` - Use simple default, no prompt needed
- `owner_org` - Remove or make optional
- `author_name` - Get from `gh_user.name` or git config
- `author_email` - Get from `gh_user.email` or git config  
- `repository_url` - Auto-generate, don't prompt

Update to:

```yaml
project_name:
  type: str
  help: What is your frontend project name?
  validator: >-
    {% if not project_name or project_name.strip() == '' %}
    Project name cannot be empty
    {% endif %}

package_name:
  type: str
  default: "{{ project_name | lower | replace(' ', '-') | replace('_', '-') }}"
  when: false  # Don't prompt, just use default

project_description:
  type: str
  default: "{{ project_name }} - A modern React application built with Vite, TypeScript, and Tailwind CSS"
  when: false

author_name:
  type: str
  default: "{{ gh_user.name if gh_user.name else ('{{ \"git config user.name\" | shell }}' or 'Alkeme Team') }}"
  when: false

author_email:
  type: str
  default: "{{ gh_user.email if gh_user.email else ('{{ \"git config user.email\" | shell }}' or 'dev@alkeme.com') }}"
  when: false

repository_url:
  type: str
  default: "{{ gh_user.html_url if gh_user.html_url else 'https://github.com/Alkeme-Insurance' }}/{{ package_name }}"
  when: false
```

### 3. Update Feature Flag Defaults (lines 98-161)

Set production-ready defaults:

```yaml
use_azure_auth:
  type: bool
  default: true
  when: false  # Don't prompt, use default

use_pwa:
  type: bool
  default: false
  when: false

use_analytics:
  type: bool
  default: true  # Changed from false
  when: false

use_cursor_rules:
  type: bool
  default: true
  when: false

use_git_hooks:
  type: bool
  default: true
  when: false
```

### 4. Update Scaffold Components (lines 166-206)

Make it auto-select all by default:

```yaml
scaffold_components:
  type: yaml
  multiselect: true
  default: [*api, *auth, *components, *pages, *lib, *types, *hooks]
  when: false  # Don't prompt, use default
```

### 5. Update Docker/Infrastructure Options (lines 208-234)

Set all to true by default:

```yaml
include_docker:
  type: bool
  default: true
  when: false

include_makefile:
  type: bool
  default: true
  when: false

include_setup_script:
  type: bool
  default: true
  when: false
```

### 6. Update Package Manager (lines 418-426)

Change default to pnpm:

```yaml
package_manager:
  type: str
  default: "pnpm"  # Changed from no default
  when: false  # Don't prompt
  choices:
    - "npm"
    - "pnpm"
    - "yarn"
```

### 7. Update Python Tooling (lines 428-447)

Set defaults, don't prompt:

```yaml
python_version:
  type: str
  default: "3.13"
  when: false

python_dependency_manager:
  type: str
  default: "uv"
  when: false
```

## Result

After these changes:

- Only 1 interactive prompt: `project_name`
- All other values auto-detected or use sensible defaults
- User info from: `gh api user` → `git config` → hardcoded fallback
- Production-ready configuration out of the box
- Users can still override via `copier copy --data key=value` if needed

## Testing

Test with:

```bash
uvx copier copy . /tmp/test-auto --trust
# Should only prompt for project_name
```