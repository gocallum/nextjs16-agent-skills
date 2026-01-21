# Clerk + Next.js 16 Code Examples

Practical code examples for common Clerk authentication patterns in Next.js 16 with App Router.

## Basic Setup Examples

### Complete Layout Setup

```typescript
// app/layout.tsx
import {
  ClerkProvider,
  SignInButton,
  SignUpButton,
  SignedIn,
  SignedOut,
  UserButton,
} from '@clerk/nextjs'
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'My App',
  description: 'Authentication with Clerk',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <ClerkProvider>
      <html lang="en">
        <body>
          {/* Navigation */}
          <nav className="flex justify-between items-center p-4 bg-slate-100">
            <h1 className="text-xl font-bold">My App</h1>
            
            <div className="flex gap-4">
              <SignedOut>
                <SignInButton mode="modal">
                  <button className="px-4 py-2 bg-blue-500 text-white rounded">
                    Sign In
                  </button>
                </SignInButton>
                <SignUpButton mode="modal">
                  <button className="px-4 py-2 bg-green-500 text-white rounded">
                    Sign Up
                  </button>
                </SignUpButton>
              </SignedOut>
              
              <SignedIn>
                <UserButton />
              </SignedIn>
            </div>
          </nav>

          {/* Main content */}
          <main className="container mx-auto p-4">
            {children}
          </main>
        </body>
      </html>
    </ClerkProvider>
  )
}
```

### Basic proxy.ts Setup

```typescript
// proxy.ts
import { clerkMiddleware } from '@clerk/nextjs/server'

export default clerkMiddleware()

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
}
```

## Route Protection Examples

### Protect All Routes

```typescript
// proxy.ts
import { clerkMiddleware } from '@clerk/nextjs/server'

export default clerkMiddleware(async (auth, req) => {
  // Protect all routes by default
  await auth.protect()
})

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
}
```

### Selective Route Protection

```typescript
// proxy.ts
import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server'

const publicRoutes = createRouteMatcher([
  '/',
  '/sign-in(.*)',
  '/sign-up(.*)',
  '/public(.*)',
])

const protectedRoutes = createRouteMatcher([
  '/dashboard(.*)',
  '/profile(.*)',
  '/api/user(.*)',
])

export default clerkMiddleware(async (auth, req) => {
  if (publicRoutes(req)) {
    // Allow public access
    return
  }
  
  if (protectedRoutes(req)) {
    // Require authentication
    await auth.protect()
  }
})

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
}
```

### Public Routes with MCP Endpoints

```typescript
// proxy.ts
import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server'

const publicRoutes = createRouteMatcher([
  '/',
  '/sign-in(.*)',
  '/sign-up(.*)',
  // OAuth metadata for MCP
  '/.well-known/oauth-authorization-server(.*)',
  '/.well-known/oauth-protected-resource(.*)',
])

export default clerkMiddleware(async (auth, req) => {
  if (!publicRoutes(req)) {
    await auth.protect()
  }
})

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
}
```

## Accessing User Data

### In Server Components

```typescript
// app/dashboard/page.tsx
import { auth, clerkClient } from '@clerk/nextjs/server'
import { redirect } from 'next/navigation'

export default async function DashboardPage() {
  const { userId } = await auth()

  if (!userId) {
    redirect('/sign-in')
  }

  // Get detailed user data
  const clerk = await clerkClient()
  const user = await clerk.users.getUser(userId)

  return (
    <div>
      <h1>Welcome, {user.fullName}!</h1>
      <p>Email: {user.primaryEmailAddress?.emailAddress}</p>
      <p>User ID: {userId}</p>
    </div>
  )
}
```

### In Client Components

```typescript
// app/components/user-profile.tsx
'use client'

import { useUser, useAuth } from '@clerk/nextjs'
import { useEffect } from 'react'

export function UserProfile() {
  const { user, isLoaded } = useUser()
  const { userId, getToken } = useAuth()

  if (!isLoaded) return <div>Loading...</div>

  if (!user) return <div>Not signed in</div>

  return (
    <div>
      <h2>{user.fullName}</h2>
      <p>{user.primaryEmailAddress?.emailAddress}</p>
      
      {user.profileImageUrl && (
        <img
          src={user.profileImageUrl}
          alt="Profile"
          className="w-16 h-16 rounded-full"
        />
      )}

      <button
        onClick={async () => {
          const token = await getToken()
          console.log('OAuth Token:', token)
        }}
      >
        Get Auth Token
      </button>
    </div>
  )
}
```

### In Server Actions

```typescript
// app/actions.ts
'use server'

import { auth, clerkClient } from '@clerk/nextjs/server'
import { revalidatePath } from 'next/cache'

export async function updateUserProfile(formData: FormData) {
  const { userId } = await auth()

  if (!userId) {
    throw new Error('Unauthorized')
  }

  const name = formData.get('name') as string
  const email = formData.get('email') as string

  try {
    const clerk = await clerkClient()
    await clerk.users.updateUser(userId, {
      firstName: name.split(' ')[0],
      lastName: name.split(' ')[1],
      primaryEmailAddress: email,
    })

    revalidatePath('/profile')
    return { success: true }
  } catch (error) {
    return { error: 'Failed to update profile' }
  }
}
```

## API Route Examples

### Protected API Route

```typescript
// app/api/user/route.ts
import { auth, clerkClient } from '@clerk/nextjs/server'
import { NextResponse } from 'next/server'

export async function GET() {
  const { userId } = await auth()

  if (!userId) {
    return NextResponse.json(
      { error: 'Unauthorized' },
      { status: 401 }
    )
  }

  try {
    const clerk = await clerkClient()
    const user = await clerk.users.getUser(userId)

    return NextResponse.json({
      id: user.id,
      email: user.primaryEmailAddress?.emailAddress,
      name: user.fullName,
    })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch user' },
      { status: 500 }
    )
  }
}
```

### Create User Metadata

```typescript
// app/api/user/metadata/route.ts
import { auth, clerkClient } from '@clerk/nextjs/server'
import { NextRequest, NextResponse } from 'next/server'

export async function PUT(request: NextRequest) {
  const { userId } = await auth()

  if (!userId) {
    return NextResponse.json(
      { error: 'Unauthorized' },
      { status: 401 }
    )
  }

  try {
    const body = await request.json()
    const clerk = await clerkClient()

    await clerk.users.updateUser(userId, {
      publicMetadata: {
        role: body.role,
        theme: body.theme,
      },
    })

    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to update metadata' },
      { status: 500 }
    )
  }
}
```

## Custom Components

### Sign Out Button

```typescript
// app/components/sign-out-button.tsx
'use client'

import { SignOutButton } from '@clerk/nextjs'

export function CustomSignOutButton() {
  return (
    <SignOutButton redirectUrl="/">
      <button className="px-4 py-2 bg-red-500 text-white rounded">
        Sign Out
      </button>
    </SignOutButton>
  )
}
```

### Role-Based Content

```typescript
// app/components/admin-panel.tsx
'use client'

import { useUser } from '@clerk/nextjs'

export function AdminPanel() {
  const { user } = useUser()

  const isAdmin = user?.publicMetadata?.role === 'admin'

  if (!isAdmin) {
    return <div>Access Denied</div>
  }

  return (
    <div>
      <h2>Admin Panel</h2>
      {/* Admin content */}
    </div>
  )
}
```

### User Menu Dropdown

```typescript
// app/components/user-menu.tsx
'use client'

import { useUser } from '@clerk/nextjs'
import { SignOutButton } from '@clerk/nextjs'
import { useState } from 'react'

export function UserMenu() {
  const { user } = useUser()
  const [open, setOpen] = useState(false)

  return (
    <div className="relative">
      <button
        onClick={() => setOpen(!open)}
        className="flex items-center gap-2"
      >
        {user?.profileImageUrl && (
          <img
            src={user.profileImageUrl}
            alt="Profile"
            className="w-8 h-8 rounded-full"
          />
        )}
        <span>{user?.firstName}</span>
      </button>

      {open && (
        <div className="absolute right-0 mt-2 w-48 bg-white rounded shadow-lg">
          <a
            href="/profile"
            className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
          >
            Profile
          </a>
          <a
            href="/settings"
            className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
          >
            Settings
          </a>
          <hr />
          <SignOutButton>
            <button className="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-100">
              Sign Out
            </button>
          </SignOutButton>
        </div>
      )}
    </div>
  )
}
```

## MCP Server Examples

### Simple MCP Tool

```typescript
// app/[transport]/route.ts
import { verifyClerkToken } from '@clerk/mcp-tools/next'
import { createMcpHandler, withMcpAuth } from '@vercel/mcp-adapter'
import { auth, clerkClient } from '@clerk/nextjs/server'

const clerk = await clerkClient()

const handler = createMcpHandler((server) => {
  server.tool(
    'get-user-profile',
    'Get the authenticated user profile',
    {},
    async (_, { authInfo }) => {
      const userId = authInfo!.extra!.userId! as string
      const user = await clerk.users.getUser(userId)

      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify({
              id: user.id,
              email: user.primaryEmailAddress?.emailAddress,
              name: user.fullName,
              role: user.publicMetadata?.role,
            }),
          },
        ],
      }
    },
  )
})

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

### MCP Tool with Input Validation

```typescript
// Parameterized MCP tool
server.tool(
  'send-email',
  'Send an email to the user',
  {
    to: {
      type: 'string',
      description: 'Recipient email address',
    },
    subject: {
      type: 'string',
      description: 'Email subject',
    },
    body: {
      type: 'string',
      description: 'Email body',
    },
  },
  async (input, { authInfo }) => {
    const userId = authInfo!.extra!.userId! as string
    const user = await clerk.users.getUser(userId)

    // Validate recipient (prevent abuse)
    if (!input.to.includes('@')) {
      throw new Error('Invalid email address')
    }

    // Send email (implement with Resend, SendGrid, etc.)
    // await sendEmail({
    //   from: 'noreply@example.com',
    //   to: input.to,
    //   subject: input.subject,
    //   body: input.body,
    // })

    return {
      content: [
        {
          type: 'text',
          text: `Email sent to ${input.to}`,
        },
      ],
    }
  },
)
```

## Error Handling Examples

### Auth Error Boundary

```typescript
// app/components/auth-error-boundary.tsx
'use client'

import { ReactNode } from 'react'

interface Props {
  children: ReactNode
  fallback?: ReactNode
}

export function AuthErrorBoundary({ children, fallback }: Props) {
  try {
    return <>{children}</>
  } catch (error) {
    if (error instanceof Error && error.message.includes('Unauthorized')) {
      return (
        <div className="p-4 bg-red-100 border border-red-400 rounded">
          <p className="text-red-700">
            {fallback || 'You need to sign in to access this content.'}
          </p>
        </div>
      )
    }
    throw error
  }
}
```

### Graceful Fallback

```typescript
// app/components/protected-section.tsx
'use client'

import { useAuth } from '@clerk/nextjs'
import { ReactNode } from 'react'

interface Props {
  children: ReactNode
  fallback?: ReactNode
}

export function ProtectedSection({ children, fallback }: Props) {
  const { userId, isLoaded } = useAuth()

  if (!isLoaded) return <div>Loading...</div>

  if (!userId) {
    return (
      fallback || (
        <div className="p-4 bg-yellow-100 border border-yellow-400 rounded">
          <p>Please sign in to see this content.</p>
        </div>
      )
    )
  }

  return <>{children}</>
}
```

## Environment Variable Validation

### Startup Validation

```typescript
// lib/validate-clerk-env.ts
export function validateClerkEnvironment() {
  const required = {
    NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY:
      process.env.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY,
    CLERK_SECRET_KEY: process.env.CLERK_SECRET_KEY,
  }

  const missing = Object.entries(required)
    .filter(([_, value]) => !value)
    .map(([key]) => key)

  if (missing.length > 0) {
    const message = `Missing required Clerk environment variables:\n${missing
      .map((k) => `  - ${k}`)
      .join('\n')}\n\nSet these in .env.local or your deployment platform.`

    if (process.env.NODE_ENV === 'production') {
      throw new Error(message)
    } else {
      console.error('⚠️ ', message)
    }
  }
}

// Call in app initialization
// app/layout.tsx
import { validateClerkEnvironment } from '@/lib/validate-clerk-env'

validateClerkEnvironment()

export default function RootLayout({ children }) {
  return /* ... */
}
```

## TypeScript Definitions

### Custom User Metadata

```typescript
// types/user.ts
import { User } from '@clerk/nextjs/server'

export interface CustomUser extends User {
  publicMetadata?: {
    role?: 'admin' | 'user' | 'moderator'
    theme?: 'light' | 'dark'
    preferences?: Record<string, unknown>
  }
}

// Usage in server components
import { auth, clerkClient } from '@clerk/nextjs/server'
import { CustomUser } from '@/types/user'

export async function getAuthenticatedUser(): Promise<CustomUser> {
  const { userId } = await auth()
  if (!userId) throw new Error('Not authenticated')

  const clerk = await clerkClient()
  return (await clerk.users.getUser(userId)) as CustomUser
}
```
