# Clerk Next.js 16 Quick Reference Card

A one-page reference for common Clerk + Next.js 16 patterns.

## Installation

```bash
# Core
pnpm add @clerk/nextjs

# Optional: MCP server
pnpm add @vercel/mcp-adapter @clerk/mcp-tools
```

## Minimal Setup (5 steps)

### 1. Create proxy.ts
```typescript
import { clerkMiddleware } from '@clerk/nextjs/server'
export default clerkMiddleware()
export const config = {
  matcher: ['/((?!_next|[^?]*\\.(?:html?|css|js|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)', '/(api|trpc)(.*)'],
}
```

### 2. Create .env.local
```env
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxx
CLERK_SECRET_KEY=sk_test_xxx
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
```

### 3. Add ClerkProvider
```typescript
// app/layout.tsx
import { ClerkProvider } from '@clerk/nextjs'

export default function RootLayout({ children }) {
  return (
    <ClerkProvider>
      <html><body>{children}</body></html>
    </ClerkProvider>
  )
}
```

### 4. Add UI Components
```typescript
import { SignInButton, SignUpButton, SignedIn, SignedOut, UserButton } from '@clerk/nextjs'

export function Header() {
  return (
    <header>
      <SignedOut>
        <SignInButton /><SignUpButton />
      </SignedOut>
      <SignedIn>
        <UserButton />
      </SignedIn>
    </header>
  )
}
```

### 5. Run
```bash
pnpm dev
```

## Common Patterns

### Get Current User (Server)
```typescript
import { auth, clerkClient } from '@clerk/nextjs/server'

const { userId } = await auth()
const clerk = await clerkClient()
const user = await clerk.users.getUser(userId)
```

### Get Current User (Client)
```typescript
'use client'
import { useUser } from '@clerk/nextjs'

const { user, isLoaded } = useUser()
```

### Protect Routes
```typescript
// All routes
export default clerkMiddleware(async (auth) => {
  await auth.protect()
})

// Specific routes
const protected = createRouteMatcher(['/dashboard(.*)', '/api/user(.*)'])
export default clerkMiddleware(async (auth, req) => {
  if (protected(req)) await auth.protect()
})
```

### Protect API Route
```typescript
import { auth } from '@clerk/nextjs/server'

export async function GET() {
  const { userId } = await auth()
  if (!userId) return Response.json({ error: 'Unauthorized' }, { status: 401 })
  // ... implementation
}
```

### Server Action
```typescript
'use server'
import { auth } from '@clerk/nextjs/server'

export async function myAction() {
  const { userId } = await auth()
  if (!userId) throw new Error('Unauthorized')
  // ... implementation
}
```

### Check Role/Metadata
```typescript
const user = await clerk.users.getUser(userId)
const isAdmin = user.publicMetadata?.role === 'admin'
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Routes not protected | Verify proxy.ts is in root or /src (not /app) |
| env vars undefined | Restart dev server: `rm -rf .next && pnpm dev` |
| Auth broken after upgrade | Rename middleware.ts → proxy.ts and update Next.js to 16 |
| CORS errors in MCP | Ensure `metadataCorsOptionsRequestHandler` exported as OPTIONS |
| Tokens rejected | Verify environment is test (dev) or live (prod) |

## File Locations

```
project/
├── proxy.ts (or src/proxy.ts)      ← Middleware
├── .env.local                      ← Environment variables
├── next.config.ts
├── app/
│   ├── layout.tsx                  ← Add ClerkProvider here
│   ├── sign-in/[[...rest]]/page.tsx
│   ├── sign-up/[[...rest]]/page.tsx
│   ├── dashboard/page.tsx          ← Protected
│   └── [transport]/route.ts        ← MCP server (optional)
└── package.json
```

## Environment Variables

```env
# Required
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxx
CLERK_SECRET_KEY=sk_test_xxx

# Optional redirects
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/

# Get keys from https://dashboard.clerk.com/
```

## Migration: Next.js 15 → 16

```bash
# 1. Rename file
mv middleware.ts proxy.ts

# 2. Update Next.js
pnpm add next@latest

# 3. Clear cache
rm -rf .next

# 4. Done! (No code changes)
```

## MCP Server Setup (Quick)

```typescript
// app/[transport]/route.ts
import { verifyClerkToken } from '@clerk/mcp-tools/next'
import { createMcpHandler, withMcpAuth } from '@vercel/mcp-adapter'
import { auth, clerkClient } from '@clerk/nextjs/server'

const clerk = await clerkClient()
const handler = createMcpHandler((server) => {
  server.tool('get-user-data', 'Get user data', {}, async (_, { authInfo }) => {
    const userId = authInfo!.extra!.userId!
    const user = await clerk.users.getUser(userId)
    return {
      content: [{ type: 'text', text: JSON.stringify(user) }],
    }
  })
})

const authHandler = withMcpAuth(
  handler,
  async (_, token) => {
    const clerkAuth = await auth({ acceptsToken: 'oauth_token' })
    return verifyClerkToken(clerkAuth, token)
  },
  { required: true, resourceMetadataPath: '/.well-known/oauth-protected-resource/mcp' },
)

export { authHandler as GET, authHandler as POST }
```

## Useful Links

- 📚 [Clerk Docs](https://clerk.com/docs)
- 🔐 [Clerk Dashboard](https://dashboard.clerk.com/)
- 💬 [Clerk Discord](https://clerk.com/discord)
- ⚙️ [Environment Variables](https://clerk.com/docs/deployments/clerk-environment-variables)
- 🔗 [OAuth Guide](https://clerk.com/docs/nextjs/guides/development/verifying-oauth-access-tokens)
- 🤖 [MCP Setup](./references/CLERK_MCP_SERVER_SETUP.md)

## TypeScript Types

```typescript
import { User } from '@clerk/nextjs/server'
import { UseUserReturn } from '@clerk/nextjs'

interface CustomUser extends User {
  publicMetadata?: {
    role?: 'admin' | 'user'
    theme?: 'light' | 'dark'
  }
}
```

## Validation at Startup

```typescript
// lib/validate-clerk.ts
export function validateClerkEnvironment() {
  const required = [
    'NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY',
    'CLERK_SECRET_KEY',
  ]
  const missing = required.filter(k => !process.env[k])
  if (missing.length > 0) {
    throw new Error(`Missing: ${missing.join(', ')}`)
  }
}

// app/layout.tsx
validateClerkEnvironment()
```

## Sign Out

```typescript
import { SignOutButton } from '@clerk/nextjs'

<SignOutButton redirectUrl="/">
  <button>Sign Out</button>
</SignOutButton>
```

## Custom Sign In/Up Pages

```typescript
// app/sign-in/[[...rest]]/page.tsx
import { SignIn } from '@clerk/nextjs'

export default function SignInPage() {
  return <SignIn />
}

// app/sign-up/[[...rest]]/page.tsx
import { SignUp } from '@clerk/nextjs'

export default function SignUpPage() {
  return <SignUp />
}
```

## Version Requirements

- **Next.js**: 16.0+ (App Router only)
- **Node.js**: 18.0+
- **@clerk/nextjs**: Latest
- **pnpm**: 8+ (or npm, yarn)

---

For complete documentation, see [SKILL.md](SKILL.md) and the references folder.
