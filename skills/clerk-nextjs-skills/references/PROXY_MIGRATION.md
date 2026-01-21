# proxy.ts vs middleware.ts: Next.js Version Migration Guide

Complete guide to migrating from Next.js 15 (middleware.ts) to Next.js 16 (proxy.ts) with Clerk.

## Quick Reference

| Aspect | Next.js ≤15 | Next.js 16 |
|--------|-----------|-----------|
| Filename | `middleware.ts` | `proxy.ts` |
| Location | Root or `/src` | Root or `/src` |
| Code | Identical | Identical |
| Setup effort | Rename file | Rename file |
| Breaking changes | None | None |

## Why the Change?

Next.js 16 introduced a new proxy-based architecture that:
- Improves performance with edge computation
- Better integrates with Next.js deployment
- Uses standardized naming (`proxy.ts` is Next.js convention for edge middleware)
- Aligns with how framework middleware is traditionally named

## What Stays the Same

The **code itself is identical**. Only the filename changes:

```typescript
// Next.js 15: middleware.ts
import { clerkMiddleware } from '@clerk/nextjs/server'

export default clerkMiddleware()

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
}
```

```typescript
// Next.js 16: proxy.ts
import { clerkMiddleware } from '@clerk/nextjs/server'

export default clerkMiddleware()

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
}
```

The only difference is the filename.

## Complete Migration Steps

### Step 1: Verify Current Setup

Identify your current Next.js version:

```bash
pnpm list next
# or
npm list next
```

Check your current middleware file:

```bash
ls middleware.ts
# or
ls src/middleware.ts
```

### Step 2: Backup Existing File (Optional)

```bash
cp middleware.ts middleware.ts.backup
```

### Step 3: Rename the File

**If middleware.ts is at root:**
```bash
mv middleware.ts proxy.ts
```

**If middleware.ts is in src:**
```bash
mv src/middleware.ts src/proxy.ts
```

### Step 4: Update Next.js to Version 16

```bash
pnpm add next@latest
pnpm install
```

Or update in `package.json` directly:

```json
{
  "dependencies": {
    "next": "^16.0.0"
  }
}
```

Then run:
```bash
pnpm install
```

### Step 5: Clear Build Cache

```bash
rm -rf .next
```

### Step 6: Test the Migration

```bash
pnpm dev
```

Visit your app and test:
1. Authentication flow still works
2. Protected routes are still protected
3. No console errors about middleware/proxy

### Step 7: Verify in Production Build

```bash
pnpm build
pnpm start
```

Test authentication again in production build.

## Common Patterns (Same in Both Versions)

### Protecting All Routes

```typescript
// Works in both middleware.ts and proxy.ts
import { clerkMiddleware } from '@clerk/nextjs/server'

export default clerkMiddleware(async (auth, req) => {
  await auth.protect()
})
```

### Protecting Specific Routes

```typescript
// Works in both middleware.ts and proxy.ts
import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server'

const isProtectedRoute = createRouteMatcher([
  '/dashboard(.*)',
  '/api/user(.*)',
])

export default clerkMiddleware(async (auth, req) => {
  if (isProtectedRoute(req)) {
    await auth.protect()
  }
})
```

### Public Routes with Opt-In Protection

```typescript
// Works in both middleware.ts and proxy.ts
import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server'

const isPublicRoute = createRouteMatcher([
  '/sign-in(.*)',
  '/sign-up(.*)',
  '/',
])

export default clerkMiddleware(async (auth, req) => {
  if (!isPublicRoute(req)) {
    await auth.protect()
  }
})
```

### Exposing .well-known Endpoints (MCP)

```typescript
// Works in both middleware.ts and proxy.ts
import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server'

const isPublicRoute = createRouteMatcher([
  '/.well-known/oauth-authorization-server(.*)',
  '/.well-known/oauth-protected-resource(.*)',
])

export default clerkMiddleware(async (auth, req) => {
  if (isPublicRoute(req)) return
  await auth.protect()
})
```

## Troubleshooting Migration

### Issue: File not recognized after rename

**Symptoms**: Routes aren't protected, authentication broken

**Solutions**:
1. Verify file is named exactly `proxy.ts` (case-sensitive)
2. Restart dev server: `pnpm dev`
3. Clear `.next` cache: `rm -rf .next && pnpm dev`
4. Verify Next.js version is 16+: `pnpm list next`

### Issue: "Cannot find middleware" error

**Symptoms**: Build fails or console shows middleware error

**Solutions**:
1. Check file is in root or `/src`, NOT in `/app`
2. Verify config export is present (required for matcher)
3. Ensure no `middleware.ts` file still exists (it will conflict)

### Issue: Changes don't take effect

**Symptoms**: Protection rules not working

**Solutions**:
1. Clear cache and restart: `rm -rf .next && pnpm dev`
2. Check file was properly renamed (not just copied)
3. Verify there's only ONE proxy.ts or middleware.ts file
4. Restart your IDE's TypeScript server (often fixes type errors)

### Issue: Type errors after migration

**Symptoms**: TypeScript complaints about types

**Solutions**:
1. Update `@clerk/nextjs`: `pnpm update @clerk/nextjs`
2. Clear cache: `rm -rf .next node_modules/.vite`
3. Restart TypeScript: Command palette → "Restart TS Server"

### Issue: Environment variables not loading

**Symptoms**: Clerk components show "Missing environment variables"

**Solutions**:
1. `.env.local` must be in project root (same level as `next.config.ts`)
2. Restart dev server after changing `.env.local`
3. Verify `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` exists

## Rollback Plan

If issues occur, roll back to middleware.ts:

```bash
# Rename proxy.ts back to middleware.ts
mv proxy.ts middleware.ts

# Downgrade Next.js
pnpm add next@15
pnpm install

# Clear cache
rm -rf .next

# Restart
pnpm dev
```

## Version Compatibility Matrix

| Next.js | Clerk Support | Middleware File |
|---------|---------------|-----------------|
| 15.x | ✅ Full support | `middleware.ts` |
| 16.x | ✅ Full support | `proxy.ts` or `middleware.ts` |
| 17+ | ✅ Full support | `proxy.ts` (recommended) |

**Note**: Next.js 16+ accepts both `middleware.ts` and `proxy.ts`, but `proxy.ts` is the recommended pattern going forward.

## Performance Considerations

### Next.js 15 (middleware.ts)

- Middleware runs on Edge Runtime
- Good for route protection
- Suitable for simple auth checks

### Next.js 16 (proxy.ts)

- Enhanced Edge Runtime with better performance
- Improved cold start times
- Better integration with deployment platforms
- Slightly faster auth checks

**Migration impact**: Expect no performance regression; typically slight improvement.

## CI/CD Considerations

### GitHub Actions

Update your workflow to use Next.js 16:

```yaml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      
      - run: pnpm install
      - run: pnpm build
      
      - name: Check for proxy.ts
        run: |
          if [ ! -f "proxy.ts" ] && [ ! -f "src/proxy.ts" ]; then
            echo "Error: proxy.ts not found"
            exit 1
          fi
```

### Docker

Update your Dockerfile:

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .

# Ensure proxy.ts exists
RUN test -f proxy.ts || test -f src/proxy.ts || exit 1

RUN pnpm build

EXPOSE 3000
CMD ["pnpm", "start"]
```

## Documentation References

### For Each Version

**Next.js 15 with middleware.ts:**
- [Clerk Middleware Docs](https://clerk.com/docs/reference/nextjs/clerk-middleware)
- [Next.js 15 Middleware](https://nextjs.org/docs/pages/building-your-application/routing/middleware)

**Next.js 16 with proxy.ts:**
- [Clerk Proxy Setup](https://clerk.com/docs/nextjs/getting-started/quickstart)
- [Next.js 16 Documentation](https://nextjs.org/docs)

## Migration Checklist

```markdown
- [ ] Verify current Next.js version
- [ ] Locate middleware.ts file
- [ ] Backup existing file
- [ ] Rename middleware.ts to proxy.ts
- [ ] Update Next.js to version 16
- [ ] Run pnpm install
- [ ] Clear .next cache
- [ ] Test dev server locally
- [ ] Test authentication flow
- [ ] Build for production
- [ ] Test production build
- [ ] Verify .well-known endpoints (if using MCP)
- [ ] Deploy to staging
- [ ] Run full authentication tests
- [ ] Deploy to production
```

## Summary

The migration from `middleware.ts` to `proxy.ts` is straightforward:

1. **Just rename the file** - No code changes needed
2. **Update Next.js** to version 16+
3. **Clear cache and restart** - `rm -rf .next && pnpm dev`
4. **Test** - Verify auth still works

All existing Clerk patterns and configurations remain identical. The change is purely a filename convention update to align with Next.js 16's new architecture.
