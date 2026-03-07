import { expect } from 'vitest'

// vitest does not expose `expect` globally by default when run with --globals=false.
// jest-dom relies on `expect.extend(...)`, so expose `expect` on the global context.
// See: https://vitest.dev/config/#globals
if (typeof globalThis !== 'undefined') {
  globalThis.expect = expect
}

if (typeof global !== 'undefined') {
  global.expect = expect
}

import '@testing-library/jest-dom'
