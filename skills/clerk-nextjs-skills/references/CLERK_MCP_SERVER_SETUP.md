# Clerk MCP Server Setup Guide

Complete guide to building and securing an MCP server with Clerk authentication in Next.js 16.

## Overview

This guide extends the Clerk-Next.js integration to secure an MCP (Model Context Protocol) server using Clerk's OAuth. The MCP server allows AI clients to invoke tools securely while authenticated with Clerk.

## Prerequisites

- Next.js 16+ with App Router
- Clerk account and project
- `proxy.ts` configured with `clerkMiddleware()`
- Environment variables set (see [CLERK_ENV_SETUP.md](CLERK_ENV_SETUP.md))

## Step 1: Install MCP Dependencies

```bash
pnpm add @vercel/mcp-adapter @clerk/mcp-tools
```

**Package Details:**
- `@vercel/mcp-adapter`: Handles MCP protocol, transports, and auth wrapper
- `@clerk/mcp-tools`: Clerk-specific helpers for token verification and metadata endpoints

## Step 2: Create MCP Route Handler

Create `app/[transport]/route.ts` to handle MCP requests:

```typescript
import { verifyClerkToken } from '@clerk/mcp-tools/next'
import { createMcpHandler, withMcpAuth } from '@vercel/mcp-adapter'
import { auth, clerkClient } from '@clerk/nextjs/server'

const clerk = await clerkClient()

// Define MCP server and tools
const handler = createMcpHandler((server) => {
  server.tool(
    'get-clerk-user-data',
    'Gets data about the Clerk user that authorized this request',
    {},
    async (_, { authInfo }) => {
      const userId = authInfo!.extra!.userId! as string
      const userData = await clerk.users.getUser(userId)

      return {
        content: [{ type: 'text', text: JSON.stringify(userData) }],
      }
    },
  )

  // Add more tools as needed
  server.tool(
    'custom-tool-name',
    'Description of what this tool does',
    {
      // Input schema in JSON Schema format
      param1: { type: 'string', description: 'First parameter' },
    },
    async (input, { authInfo }) => {
      const userId = authInfo!.extra!.userId! as string
      // Implementation
      return {
        content: [{ type: 'text', text: 'Result' }],
      }
    },
  )
})

// Wrap handler with OAuth authentication
const authHandler = withMcpAuth(
  handler,
  async (_, token) => {
    const clerkAuth = await auth({ acceptsToken: 'oauth_token' })
    return verifyClerkToken(clerkAuth, token)
  },
  {
    required: true,
    resourceMetadataPath: '/.well-known/oauth-protected-resource/mcp',
  },
)

export { authHandler as GET, authHandler as POST }
```

## Step 3: Create OAuth Metadata Endpoints

### 3a. Protected Resource Metadata

Create `app/.well-known/oauth-protected-resource/mcp/route.ts`:

```typescript
import { protectedResourceHandlerClerk } from '@clerk/mcp-tools/next'

const handler = protectedResourceHandlerClerk({
  scopes: ['profile', 'email'], // Scopes your MCP server supports
})

export { handler as GET }
```

### 3b. Authorization Server Metadata

Create `app/.well-known/oauth-authorization-server/route.ts`:

```typescript
import {
  authServerMetadataHandlerClerk,
  metadataCorsOptionsRequestHandler,
} from '@clerk/mcp-tools/next'

const handler = authServerMetadataHandlerClerk()
const corsHandler = metadataCorsOptionsRequestHandler()

export { handler as GET, corsHandler as OPTIONS }
```

## Step 4: Update proxy.ts to Allow Public Access to .well-known Endpoints

Modify your `proxy.ts` to ensure `.well-known` endpoints remain public:

```typescript
import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server'

const isPublicRoute = createRouteMatcher([
  '/.well-known/oauth-authorization-server(.*)',
  '/.well-known/oauth-protected-resource(.*)',
])

export default clerkMiddleware(async (auth, req) => {
  if (isPublicRoute(req)) return // Allow public access to .well-known endpoints
  await auth.protect() // Protect all other routes
})

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
}
```

## Step 5: Enable Dynamic Client Registration

1. Go to [Clerk Dashboard](https://dashboard.clerk.com/)
2. Navigate to **OAuth Applications**
3. Toggle **Dynamic Client Registration** to **ON**

This allows MCP clients to automatically register themselves during the OAuth flow.

## Step 6: Test Your MCP Server

### Testing Locally

1. Start your Next.js app:
   ```bash
   pnpm dev
   ```

2. Verify OAuth metadata endpoints are accessible:
   ```bash
   curl http://localhost:3000/.well-known/oauth-authorization-server
   curl http://localhost:3000/.well-known/oauth-protected-resource/mcp
   ```

3. Check MCP endpoint responds (requires OAuth token):
   ```bash
   curl http://localhost:3000/mcp
   ```

### Testing with Example Repository

Clone and test with Clerk's example:
```bash
git clone https://github.com/clerk/mcp-nextjs-example
cd mcp-nextjs-example
pnpm install
pnpm dev
```

## Directory Structure

```
app/
  [transport]/
    route.ts                 # MCP handler
  .well-known/
    oauth-authorization-server/
      route.ts              # Authorization server metadata
    oauth-protected-resource/
      mcp/
        route.ts            # Protected resource metadata
  layout.tsx
  page.tsx
proxy.ts                      # Clerk middleware (exposes .well-known)
```

## Environment Variables

Ensure all these are in `.env.local`:

```env
# Clerk Keys
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=your_publishable_key
CLERK_SECRET_KEY=your_secret_key

# Optional: MCP-specific configuration
MCP_SCOPES=profile email
DEBUG_MCP=false
```

## Advanced: Custom Tools with MCP

### Example: Database Query Tool

```typescript
server.tool(
  'query-database',
  'Query the application database for user-related data',
  {
    query: {
      type: 'string',
      description: 'SQL-like query string',
    },
    limit: {
      type: 'number',
      description: 'Result limit (default: 10)',
    },
  },
  async (input, { authInfo }) => {
    const userId = authInfo!.extra!.userId! as string
    
    // Verify user has permission to query
    const user = await clerk.users.getUser(userId)
    
    if (!user.publicMetadata?.isAdmin) {
      throw new Error('Unauthorized: admin access required')
    }

    // Execute query
    const results = await db.query(input.query, { limit: input.limit })

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(results, null, 2),
        },
      ],
    }
  },
)
```

### Example: File Upload Tool

```typescript
server.tool(
  'upload-file',
  'Upload a file to user storage',
  {
    filename: { type: 'string', description: 'Name of the file' },
    content: { type: 'string', description: 'Base64-encoded file content' },
  },
  async (input, { authInfo }) => {
    const userId = authInfo!.extra!.userId! as string
    
    const buffer = Buffer.from(input.content, 'base64')
    const path = `uploads/${userId}/${input.filename}`
    
    await storage.put(path, buffer)

    return {
      content: [
        {
          type: 'text',
          text: `File uploaded successfully: ${path}`,
        },
      ],
    }
  },
)
```

## Troubleshooting MCP Setup

| Issue | Solution |
|-------|----------|
| OAuth metadata endpoints return 404 | Ensure `.well-known` routes are public in `proxy.ts` matcher |
| MCP tools return "Unauthorized" | Check Dynamic Client Registration is enabled in Clerk Dashboard |
| OAuth token verification fails | Verify `acceptsToken: 'oauth_token'` is set in `auth()` call |
| `authInfo` is undefined in tool | Ensure token is passed in request header: `Authorization: Bearer <token>` |
| CORS errors accessing metadata | Verify `metadataCorsOptionsRequestHandler` is exported as `OPTIONS` handler |
| Tools not appearing in client | Check MCP server is registered correctly and responding to `GET /[transport]` |

## Security Best Practices

1. **Token Scope Validation**: Always verify token scopes match required access level
   ```typescript
   if (!authInfo.scopes?.includes('required-scope')) {
     throw new Error('Insufficient permissions')
   }
   ```

2. **Rate Limiting**: Implement rate limits for MCP tools
   ```typescript
   const rateLimiter = new Map<string, number[]>()
   // Track and limit requests per userId
   ```

3. **Input Validation**: Sanitize all tool inputs
   ```typescript
   import { z } from 'zod'
   
   const querySchema = z.object({
     query: z.string().min(1).max(1000),
   })
   
   const input = querySchema.parse(toolInput)
   ```

4. **Audit Logging**: Log all MCP tool invocations
   ```typescript
   console.log(`[MCP] ${userId} called ${toolName} at ${new Date().toISOString()}`)
   ```

5. **Secrets Management**: Never expose secrets in tool responses
   ```typescript
   // ❌ Bad: Exposes secret
   return { secret: process.env.SECRET }
   
   // ✅ Good: Only expose necessary data
   return { success: true }
   ```

## Performance Optimization

### Caching User Data

```typescript
const userCache = new Map<string, CacheEntry>()

async function getCachedUser(userId: string) {
  const cached = userCache.get(userId)
  if (cached && Date.now() - cached.timestamp < 60000) {
    return cached.data
  }

  const user = await clerk.users.getUser(userId)
  userCache.set(userId, { data: user, timestamp: Date.now() })
  return user
}
```

### Reusing clerkClient Instance

```typescript
// At module level (already awaited)
const clerk = await clerkClient()

// Use in all tools without re-awaiting
const user = await clerk.users.getUser(userId)
```

## Migration from Old MCP Setup

If migrating from an older MCP implementation:

1. Update `@vercel/mcp-adapter` to latest version
2. Replace `mcp-handler` with `createMcpHandler` and `withMcpAuth`
3. Update metadata endpoints to use Clerk's handlers
4. Ensure `.well-known` routes are in new structure
5. Test OAuth token flow end-to-end

## Related Documentation

- [MCP Specification](https://modelcontextprotocol.io/)
- [Clerk OAuth Documentation](https://clerk.com/docs/reference/oauth)
- [Vercel MCP Adapter](https://github.com/vercel/mcp-adapter)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)
