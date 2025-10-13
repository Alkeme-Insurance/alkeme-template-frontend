/// <reference types="vite/client" />

// Extend Window interface for runtime environment
interface Window {
  __ENV__?: {
    APP_API_BASE_URL?: string
    APP_AZURE_CLIENT_ID?: string
    APP_AZURE_TENANT_ID?: string
    APP_AZURE_API_SCOPE?: string
    APP_DEV_NO_AUTH?: string
    APP_ENVIRONMENT?: string
  }
}

