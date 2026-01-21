# Clerk Next.js 16 Authentication Skill

Complete skill for implementing Clerk authentication in Next.js 16 applications with App Router.

## What This Skill Covers

- ✅ **Clerk Setup**: Quick start guide for Next.js 16 (App Router only)
- ✅ **proxy.ts Configuration**: Next.js 16 authentication middleware (replaces middleware.ts)
- ✅ **Environment Variables**: Proper setup and validation of Clerk keys
- ✅ **Migration Guide**: Step-by-step migration from Next.js 15 middleware.ts to Next.js 16 proxy.ts
- ✅ **MCP Server Integration**: Securing MCP servers with Clerk OAuth
- ✅ **pnpm Support**: All examples use pnpm package manager
- ✅ **Code Examples**: Practical patterns for common authentication scenarios
- ✅ **Route Protection**: Public, protected, and conditional route patterns
- ✅ **User Data Access**: Server components, client components, and server actions
- ✅ **Troubleshooting**: Common issues and solutions

## Quick Navigation

| File | Purpose |
|------|---------|
| [SKILL.md](SKILL.md) | Main skill - Start here for setup and key concepts |
| [references/CLERK_ENV_SETUP.md](references/CLERK_ENV_SETUP.md) | Environment variable configuration and validation |
| [references/PROXY_MIGRATION.md](references/PROXY_MIGRATION.md) | Migrating from middleware.ts (Next.js 15) to proxy.ts (Next.js 16) |
| [references/CLERK_MCP_SERVER_SETUP.md](references/CLERK_MCP_SERVER_SETUP.md) | Building and securing MCP servers with Clerk |
| [references/EXAMPLES.md](references/EXAMPLES.md) | Code examples and patterns |
| [scripts/setup-clerk-nextjs.sh](scripts/setup-clerk-nextjs.sh) | Automated setup script |

## Installation

### For Claude Code
```bash
cp -r clerk-nextjs-skills ~/.claude/skills/
```

### For GitHub Copilot (VS Code)
Copy the `clerk-nextjs-skills` folder to:
- `.github/skills/` or `.vscode/skills/` in your project

### For claude.ai
Paste the contents of [SKILL.md](SKILL.md) into your conversation.

## Key Features

### 1. Next.js 16 Support
- Fully compatible with Next.js 16+ (App Router only)
- Understands the change from `middleware.ts` (Next.js 15) to `proxy.ts` (Next.js 16)
- No functional differences—just a filename change

### 2. Complete Setup
Includes everything needed to add Clerk authentication:
- Package installation with pnpm
- proxy.ts middleware configuration
- Environment variable setup
- ClerkProvider integration
- Route protection patterns

### 3. Migration Assistance
Helps teams migrate from:
- Next.js 15 with `middleware.ts` to Next.js 16 with `proxy.ts`
- Step-by-step instructions with no code changes required
- Troubleshooting common migration issues

### 4. MCP Server Security
Building agentic applications?
- Secure MCP servers with Clerk OAuth
- Dynamic client registration
- Token verification and validation
- Metadata endpoint setup

### 5. Environment Management
- Development (.env.local) configuration
- Production deployment setup
- Key validation at startup
- Troubleshooting missing variables

## Quick Start

### Option 1: Automated Setup
```bash
bash clerk-nextjs-skills/scripts/setup-clerk-nextjs.sh

# With MCP server support
bash clerk-nextjs-skills/scripts/setup-clerk-nextjs.sh --mcp
```

### Option 2: Manual Setup
1. Install Clerk: `pnpm add @clerk/nextjs`
2. Create `proxy.ts` in project root or `/src`
3. Set environment variables in `.env.local`
4. Add `ClerkProvider` to `app/layout.tsx`
5. Start dev server: `pnpm dev`

See [SKILL.md](SKILL.md) for detailed instructions.

## Common Use Cases

### Protecting Routes
```typescript
// Protect all routes
export default clerkMiddleware(async (auth, req) => {
  await auth.protect()
})

// Protect specific routes
const protectedRoutes = createRouteMatcher(['/dashboard(.*)', '/api/user(.*)'])
```

### Accessing User Data
```typescript
// Server component
const { userId } = await auth()
const user = await clerk.users.getUser(userId)

// Client component
const { user } = useUser()
```

### Building MCP Servers
```typescript
server.tool('get-user-data', '...', {}, async (_, { authInfo }) => {
  const userId = authInfo!.extra!.userId! as string
  return clerk.users.getUser(userId)
})
```

## Related Skills

- **[nextjs16-skills](../nextjs16-skills/)**: Next.js 16 features and breaking changes
- **[mcp-server-skills](../mcp-server-skills/)**: General MCP server patterns with Vercel adapter
- **[authjs-skills](../authjs-skills/)**: Alternative authentication with Auth.js

## Environment Requirements

- **Node.js**: 18+ (recommended: 20+)
- **Next.js**: 16.0+ (must be App Router)
- **Package Manager**: pnpm (also supports npm)
- **Clerk Account**: Free tier available at https://clerk.com

## Support & Resources

- [Clerk Documentation](https://clerk.com/docs)
- [Clerk Dashboard](https://dashboard.clerk.com/)
- [Clerk Support](https://clerk.com/contact/support)
- [Clerk Discord Community](https://clerk.com/discord)
- [Next.js Documentation](https://nextjs.org/docs)

## Troubleshooting

### Common Issues

**proxy.ts not recognized**
- Ensure file is named exactly `proxy.ts` (not middleware.ts or Proxy.ts)
- Verify it's in project root or `/src` directory, NOT in `/app`

**Environment variables undefined**
- `.env.local` must be in project root (same level as next.config.ts)
- Restart dev server after changing .env.local
- Verify variable names match exactly (case-sensitive)

**Authentication not working**
- Check Clerk keys are from the correct environment (test vs live)
- Clear browser cookies
- Verify ClerkProvider wraps app in layout.tsx
- Check `.well-known` endpoints if using MCP

See [SKILL.md](SKILL.md) troubleshooting section for more solutions.

## Version Support

| Next.js | Support | File |
|---------|---------|------|
| 15.x | ✅ | middleware.ts |
| 16.x | ✅ | proxy.ts |
| 17+ | ✅ | proxy.ts |

**Note**: This skill focuses on Next.js 16+ with proxy.ts. Use [authjs-skills](../authjs-skills/) for Auth.js alternative.

## Contributing

Found an issue or have a suggestion? Please open an issue or pull request on the repository.

---

**Last Updated**: January 2026  
**Next.js Version**: 16.0+  
**Clerk Version**: Latest
