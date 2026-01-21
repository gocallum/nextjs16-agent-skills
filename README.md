# Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions that extend agent capabilities with specialized knowledge about Next.js, Prisma, AI SDK, Auth.js, and more.

Skills follow the [Agent Skills](https://agentskills.io/) open standard and work with **Claude Code**, **GitHub Copilot**, **Google Antigravity**, and other compatible agents.

## Why Latest Versions?

These skills focus on the **newest major versions** of popular frameworks because:

- **Breaking Changes**: Next.js 16, Prisma ORM v7, AI SDK 6, and Auth.js v5 all introduce significant breaking changes that AI agents need to understand to generate correct, modern code
- **Outdated Training Data**: Most AI models were trained on older versions and will generate deprecated patterns without explicit guidance
- **Upgrade Assistance**: Skills help you migrate existing projects by documenting the exact changes, codemods, and migration paths
- **Latest Patterns**: Each skill captures current best practices—async request APIs in Next.js 16, ESM-only in Prisma 7, ToolLoopAgent in AI SDK 6—so your code stays idiomatic

When you use these skills, your AI agent produces code that works with today's APIs, not yesterday's.

## Available Skills

### 🤖 AI & Agents

#### ai-agents-ui-skills
Building agentic applications with ToolLoopAgent, workflow patterns, and AI SDK UI components (useChat, generative UIs, tool calling).

#### ai-sdk-6-skills
AI SDK 6 Beta overview including agents, tool approval, Groq (Llama), and Vercel AI Gateway. Key breaking changes from v5 and new patterns.

#### mcp-server-skills
Pattern for building MCP servers in Next.js with mcp-handler, shared Zod schemas, and reusable server actions.

### 📧 Integrations & Services

#### resend-integration-skills
Integrate Resend email service via MCP protocol for AI agents to send emails with GitHub Copilot Coding Agent, VS Code, Claude Desktop, and Cursor. Set up transactional and marketing emails, configure sender verification, and use AI to automate email workflows. **Recommended for GitHub Copilot Coding Agent teams.**

### 🚀 Framework & Infrastructure

#### nextjs16-skills
Key facts and breaking changes for Next.js 16. Covers Turbopack bundler, async request APIs, and upgrade path.

#### prisma-orm-v7-skills
Key facts and breaking changes for upgrading to Prisma ORM 7. Covers ESM-only migration, driver adapters, and prisma.config.ts.

#### shadcn-skills
Installation, components, blocks, forms, theming, and MCP guidance for shadcn/ui in modern Next.js projects.

### 🔐 Authentication & Security

#### clerk-nextjs-skills
Clerk authentication for Next.js 16 (App Router only) with proxy.ts setup, migration from middleware.ts (Next.js 15), environment configuration, and MCP server integration. Includes OAuth token verification and dynamic client registration.

#### authjs-skills
Auth.js v5 setup for Next.js authentication including Google OAuth, credentials provider, environment configuration, and core API integration.

### 💾 Data & Storage

#### upstash-vector-db-skills
Upstash Vector DB setup, semantic search, namespaces, and embedding models (MixBread preferred). Use when building vector search features on Vercel.

### 📋 Product & Business Analysis

#### ba-prd-skills
PRD Mastery skill for context-aware, expert-driven, and token-efficient Product Requirements Documents.

## Installation

### Quick Install (npx skills)

Install skills directly using the [skills CLI](https://www.npmjs.com/package/skills):

```bash
npx skills add gocallum/nextjs16-agent-skills
```

### Manual Installation

#### Claude Code

Copy the skill folder to your Claude skills directory:

```bash
# Clone the repository
git clone https://github.com/gocallum/nextjs16-agent-skills.git

# Copy a specific skill
cp -r nextjs16-agent-skills/skills/nextjs16-skills ~/.claude/skills/

# Or copy all skills
cp -r nextjs16-agent-skills/skills/* ~/.claude/skills/
```

#### GitHub Copilot (VS Code)

Copy skills to your project's `.github/skills/` or `.vscode/skills/` folder:

```bash
# In your project root
mkdir -p .github/skills

# Copy skills from cloned repo
cp -r /path/to/nextjs16-agent-skills/skills/nextjs16-skills .github/skills/

# Or copy all skills
cp -r /path/to/nextjs16-agent-skills/skills/* .github/skills/
```

Alternative: Create a `.vscode/skills/` folder instead if you prefer project-level isolation.

#### Cursor

Copy skills to your project's `.cursor/skills/` folder:

```bash
mkdir -p .cursor/skills
cp -r /path/to/nextjs16-agent-skills/skills/* .cursor/skills/
```

#### claude.ai (Project Knowledge)

1. Download the skill's `SKILL.md` file
2. Go to your Claude.ai project settings
3. Add the file to Project Knowledge

Or paste the contents of `SKILL.md` directly into your conversation.

## Skill Structure

Each skill follows a consistent structure:

```
skills/
  {skill-name}/
    SKILL.md              # Required: skill definition with frontmatter
    scripts/              # Optional: helper scripts
    references/           # Optional: additional documentation
```

### SKILL.md Format

```markdown
---
name: {skill-name}
description: {One sentence describing when to use this skill}
---

## Links
{Documentation links}

## Quick Start
{Setup instructions}

## Code Examples
{Working examples}

## Best Practices
{Recommendations}

## Troubleshooting
{Common issues}
```

## Technology Stack

| Technology | Version |
|-----------|---------|
| Next.js | 16 |
| Prisma ORM | v7 |
| AI SDK | 6 (Beta) |
| Auth.js | v5 |
| Upstash Vector | Latest |
| Resend Email API | Latest |
| MCP Protocol | Latest |
| TypeScript | 5+ |

## Contributing

1. Fork the repository
2. Create a new skill folder in `skills/`
3. Add a `SKILL.md` following the format above
4. Test with your preferred AI agent
5. Submit a pull request

See [AGENTS.md](AGENTS.md) for detailed contribution guidelines, [CLAUDE.md](CLAUDE.md) for Claude Code and claude.ai instructions, [COPILOT.md](COPILOT.md) for GitHub Copilot instructions, and [ANTIGRAVITY.md](ANTIGRAVITY.md) for Google Antigravity instructions.

## Resources

- [Agent Skills Ecosystem](https://agentskills.io/)
- [VS Code Agent Skills Docs](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [AI SDK Documentation](https://v6.ai-sdk.dev/docs)
- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
- [Auth.js Documentation](https://authjs.dev/)
- [Upstash Vector DB](https://upstash.com/docs/vector/overall/getstarted)
- [Resend Email API](https://resend.com/docs)
- [MCP Protocol](https://modelcontextprotocol.io)

## Author

**Callum Bir** - [@gocallum](https://github.com/gocallum)

## License

MIT
