import { afterEach, vi } from 'vitest'
import { cleanup } from '@testing-library/react'
import '@testing-library/jest-dom'

// Cleanup after each test
afterEach(() => {
  cleanup()
})

// Mock window.__ENV__
(globalThis as any).window = {
  ...(globalThis as any).window,
  __ENV__: {
    APP_API_BASE_URL: 'http://localhost:8000',
    APP_AZURE_CLIENT_ID: 'test-client-id',
    APP_AZURE_TENANT_ID: 'test-tenant-id',
    APP_AZURE_API_SCOPE: 'api://test/access_as_user',
    APP_DEV_NO_AUTH: 'true',
    APP_ENVIRONMENT: 'test',
  },
}

// Mock IntersectionObserver
global.IntersectionObserver = vi.fn().mockImplementation(() => ({
  observe: vi.fn(),
  unobserve: vi.fn(),
  disconnect: vi.fn(),
}))

// Mock ResizeObserver
global.ResizeObserver = vi.fn().mockImplementation(() => ({
  observe: vi.fn(),
  unobserve: vi.fn(),
  disconnect: vi.fn(),
}))

// Mock matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: vi.fn().mockImplementation((query) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: vi.fn(),
    removeListener: vi.fn(),
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
    dispatchEvent: vi.fn(),
  })),
})

