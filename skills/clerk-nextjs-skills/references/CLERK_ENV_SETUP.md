# Clerk Environment Setup Guide

Complete guide to configuring Clerk environment variables for Next.js 16 applications.

## Required Environment Variables

All Clerk projects require these two keys in `.env.local`:

```env
# Get from https://dashboard.clerk.com/
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_your_publishable_key
CLERK_SECRET_KEY=sk_test_your_secret_key
```

### Getting Your Keys

1. Go to [Clerk Dashboard](https://dashboard.clerk.com/)
2. Select your application
3. Go to **API Keys** in the left sidebar
4. Copy the **Publishable Key** → `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`
5. Copy the **Secret Key** → `CLERK_SECRET_KEY`

## Optional Redirect URLs

Configure where users go after signing in/up:

```env
# Sign-in page URL (optional, defaults to /sign-in)
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in

# Sign-up page URL (optional, defaults to /sign-up)
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up

# After successful sign-in (optional, defaults to /)
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/

# After successful sign-up (optional, defaults to /)
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/onboarding
```

## Development vs Production Environment Variables

### Development (.env.local)

For local development, use Clerk's **Test** keys:

```env
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxx
CLERK_SECRET_KEY=sk_test_xxx
```

These are safe to commit to version control (though not recommended). Test keys work with:
- Test users
- Mock data
- Staging environments

### Production (Deployment)

Use Clerk's **Live** keys in production:

```env
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_xxx
CLERK_SECRET_KEY=sk_live_xxx
```

Set these in your deployment platform:
- **Vercel**: Project Settings → Environment Variables
- **Other platforms**: Follow their env var documentation

## Complete Environment Configuration

### Development

Create `.env.local`:

```env
# Clerk Keys (Test environment)
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxx
CLERK_SECRET_KEY=sk_test_xxx

# Auth URLs
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/onboarding

# Optional: Debug logging
DEBUG_CLERK=false
```

### Staging/Production (Vercel)

1. Go to your Vercel project settings
2. **Environment Variables** tab
3. Add for each environment (Preview, Production):

```env
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_xxx
CLERK_SECRET_KEY=sk_live_xxx

NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/onboarding
```

## Validating Environment Variables

Check for missing or invalid configuration at startup:

```typescript
// lib/validate-clerk.ts
export function validateClerkEnvironment() {
  const required = {
    'NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY': process.env.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY,
    'CLERK_SECRET_KEY': process.env.CLERK_SECRET_KEY,
  }

  const missing = Object.entries(required)
    .filter(([_, value]) => !value)
    .map(([key]) => key)

  if (missing.length > 0) {
    throw new Error(
      `Missing required Clerk environment variables:\n${missing.map(k => `  - ${k}`).join('\n')}\n\nSet these in .env.local or your deployment platform.`
    )
  }

  // Validate format
  if (!process.env.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY?.startsWith('pk_')) {
    console.warn('⚠️  NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY should start with pk_')
  }

  if (!process.env.CLERK_SECRET_KEY?.startsWith('sk_')) {
    console.warn('⚠️  CLERK_SECRET_KEY should start with sk_')
  }
}

// Call in app initialization
// Run this in app/layout.tsx or app/page.tsx (server component)
if (process.env.NODE_ENV === 'development') {
  validateClerkEnvironment()
}
```

Call validation at startup:

```typescript
// app/layout.tsx
import { validateClerkEnvironment } from '@/lib/validate-clerk'

validateClerkEnvironment()

export default function RootLayout({...}) {
  // ...
}
```

## Environment Variables for MCP Server

When building an MCP server with Clerk, add these optional variables:

```env
# MCP Configuration
MCP_TRANSPORT=http-sse
MCP_SCOPES=profile email
MCP_ENABLE_DEBUG=false

# OAuth
NEXT_PUBLIC_OAUTH_AUDIENCE=https://your-app.com
```

## Public vs Private Keys

### Public Keys (NEXT_PUBLIC_*)

These are exposed to the browser and can be safely made public:

```env
# ✅ Safe to expose
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxx
```

Anyone can see this in browser DevTools, network requests, etc.

### Secret Keys

These must NEVER be exposed to the browser:

```env
# ❌ NEVER expose to frontend
CLERK_SECRET_KEY=sk_test_xxx
```

Only use in:
- Server-side files
- API routes
- Server actions
- Build scripts

## Common Issues & Solutions

### Issue: Environment variables not loading

**Symptoms**: `process.env.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` is undefined

**Solutions**:
1. Ensure `.env.local` is in project root (same level as `next.config.ts`)
2. Restart dev server: `pnpm dev` (killing and restarting)
3. Verify variable names match exactly (case-sensitive)
4. Check `.env.local` is not in `.gitignore` (intentionally not committed)

### Issue: "Not authenticated" in development

**Symptoms**: Users can't sign in locally

**Solutions**:
1. Verify keys are from **Test** environment in Clerk Dashboard
2. Check `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` is correct
3. Clear browser cookies: DevTools → Application → Cookies → Clear
4. Check Clerk Dashboard OAuth settings allow localhost

### Issue: Wrong environment variables in production

**Symptoms**: Production deployment uses test keys

**Solutions**:
1. Verify Vercel (or platform) has **Live** Clerk keys set
2. Check environment variable is set for the correct deployment (Production vs Preview)
3. Redeploy after setting variables: `git push`
4. Check variable wasn't overridden by `.env.production.local`

### Issue: Variables visible in built output

**Symptoms**: Secret key appears in `node_modules/.cache` or `.next`

**Solutions**:
1. Ensure secret key is NOT prefixed with `NEXT_PUBLIC_`
2. Verify `CLERK_SECRET_KEY` is not exposed in build output
3. Add to `.gitignore`:
   ```
   .env.local
   .env.*.local
   .next/
   ```

## Using Environment Variables in Code

### Server-Side (Server Components, API Routes, Server Actions)

```typescript
// app/api/clerk-info/route.ts
export async function GET() {
  const key = process.env.CLERK_SECRET_KEY
  // Use secret key here
  return Response.json({ success: true })
}
```

```typescript
// app/dashboard/page.tsx
export default async function Page() {
  // Server component - can access secrets
  const apiKey = process.env.CLERK_SECRET_KEY
  return <div>Dashboard</div>
}
```

### Client-Side

```typescript
// app/components/auth.tsx
'use client'

export function AuthComponent() {
  // ONLY access NEXT_PUBLIC_* variables in client
  const publishable = process.env.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
  
  // ❌ This will be undefined in browser
  // const secret = process.env.CLERK_SECRET_KEY
  
  return <div>{publishable}</div>
}
```

## File Placement

```
project-root/
├── .env.local                    # Development (git-ignored)
├── .env.production.local         # Production (git-ignored, local only)
├── .env.example                  # Tracked: shows required vars
├── .gitignore                    # Must include .env.local
├── next.config.ts
├── proxy.ts
└── app/
    └── layout.tsx
```

### .env.example (commit this)

```env
# Copy this file to .env.local and fill in values from https://dashboard.clerk.com/

# Required
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=your_publishable_key_here
CLERK_SECRET_KEY=your_secret_key_here

# Optional
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/
```

### .gitignore (ensure this exists)

```
# Environment variables
.env.local
.env.*.local

# Next.js
.next/
out/

# Dependencies
node_modules/
```

## Rotating Keys

If you suspect a key has been exposed:

1. Go to [Clerk Dashboard](https://dashboard.clerk.com/)
2. API Keys section
3. Click "Regenerate" on compromised key
4. Update environment variables everywhere:
   - `.env.local`
   - Deployment platform
   - Any external services using the key
5. Restart all running applications

## Multi-Environment Setup

For managing multiple environments (dev, staging, production):

### Option 1: Vercel (Recommended)

```
Vercel Project → Settings → Environment Variables
├── NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxx (Preview)
├── NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_xxx (Production)
├── CLERK_SECRET_KEY=sk_test_xxx (Preview)
└── CLERK_SECRET_KEY=sk_live_xxx (Production)
```

### Option 2: Docker/Manual Deployment

```dockerfile
# Dockerfile
FROM node:20

WORKDIR /app
COPY . .

RUN pnpm install
RUN pnpm build

# Environment variables passed at runtime
CMD ["pnpm", "start"]
```

Run with environment variables:
```bash
docker run \
  -e NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_xxx \
  -e CLERK_SECRET_KEY=sk_live_xxx \
  your-app:latest
```

## Related Resources

- [Clerk Dashboard](https://dashboard.clerk.com/)
- [Clerk Environment Variables Reference](https://clerk.com/docs/deployments/clerk-environment-variables)
- [Next.js Environment Variables](https://nextjs.org/docs/basic-features/environment-variables)
- [Vercel Environment Variables](https://vercel.com/docs/environment-variables)
