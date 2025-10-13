#!/usr/bin/env sh
# Runtime environment injection for {{ project_name }}
# This script generates /env.js at container startup with whitelisted environment variables
# Allows configuration changes without rebuilding the Docker image

set -eu

ENV_JS="/usr/share/nginx/html/env.js"

echo "🔧 Generating runtime environment configuration at ${ENV_JS}"

# Create the env.js file with window.__ENV__ object
cat > "$ENV_JS" << 'EOF'
// Generated at container startup - DO NOT EDIT
// This file exposes whitelisted environment variables to the frontend
window.__ENV__ = {
EOF

# Whitelist of safe environment variables to expose to the client
# Only variables prefixed with APP_ are exposed to prevent secret leakage
# NEVER expose backend tokens, database credentials, or API secrets here
VAR_NAMES="
  APP_API_BASE_URL
  APP_AZURE_CLIENT_ID
  APP_AZURE_TENANT_ID
  APP_AZURE_API_SCOPE
  APP_DEV_NO_AUTH
  APP_ENVIRONMENT
"

# Export each whitelisted variable to env.js
for var_name in $VAR_NAMES; do
    # Get the value or empty string if not set
    value=$(printenv "$var_name" 2>/dev/null || echo "")
    
    # Escape double quotes and backslashes for JavaScript string safety
    escaped_value=$(printf '%s' "$value" | sed 's/\\/\\\\/g; s/"/\\"/g')
    
    # Write the variable to env.js
    echo "  ${var_name}: \"${escaped_value}\"," >> "$ENV_JS"
    
    # Log (be careful not to log secrets in production)
    if [ -n "$value" ]; then
        echo "  ✓ ${var_name} configured"
    else
        echo "  ⚠ ${var_name} not set (using empty string)"
    fi
done

# Close the JavaScript object
echo "};" >> "$ENV_JS"

echo "✅ Runtime environment configuration complete"
echo ""
echo "Starting Nginx..."

# Execute the CMD (nginx)
exec "$@"

