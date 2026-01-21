# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Repository Overview

A collection of skills for AI coding agents working with modern full-stack applications. Skills are packaged instructions that extend agent capabilities with specialized knowledge about Next.js, Prisma, AI SDK, Auth.js, and more.

Skills follow the [Agent Skills](https://agentskills.io/) format.

## Available Skills

| Skill | Description |
|-------|-------------|
| `ai-agents-ui-skills` | Building agentic applications with ToolLoopAgent, workflow patterns, and AI SDK UI components (useChat, generative UIs, tool calling) |
| `ai-sdk-6-skills` | AI SDK 6 Beta overview, agents, tool approval, Groq (Llama), and Vercel AI Gateway. Key breaking changes from v5 and new patterns. |
| `authjs-skills` | Auth.js v5 setup for Next.js authentication including Google OAuth, credentials provider, environment configuration, and core API integration |
| `ba-prd-skills` | PRD Mastery skill for context-aware, expert-driven, and token-efficient Product Requirements Documents |
| `clerk-nextjs-skills` | Clerk authentication for Next.js 16 (App Router) with proxy.ts middleware, Next.js 15→16 migration, environment setup, and MCP server OAuth security |
| `mcp-server-skills` | Pattern for building MCP servers in Next.js with mcp-handler, shared Zod schemas, and reusable server actions |
| `nextjs16-skills` | Key facts and links for Next.js 16. Use for planning, writing, and troubleshooting Next.js 16 changes. |
| `prisma-orm-v7-skills` | Key facts and breaking changes for upgrading to Prisma ORM 7. Consider version 7 changes before generation or troubleshooting |
| `shadcn-skills` | Installation, components, blocks, forms, theming, and MCP guidance for shadcn/ui in modern Next.js projects |
| `upstash-vector-db-skills` | Upstash Vector DB setup, semantic search, namespaces, and embedding models (MixBread preferred). Use when building vector search features on Vercel. |

## Creating a New Skill

### Directory Structure

```
skills/
  {skill-name}/           # kebab-case directory name
    SKILL.md              # Required: skill definition
    scripts/              # Optional: executable scripts
      {script-name}.sh    # Bash scripts (preferred)
    references/           # Optional: supporting documentation
  {skill-name}.zip        # Optional: packaged for distribution
```

### Naming Conventions

- **Skill directory**: `kebab-case` (e.g., `nextjs16-skills`, `prisma-orm-v7-skills`)
- **SKILL.md**: Always uppercase, always this exact filename
- **Scripts**: `kebab-case.sh` (e.g., `migrate.sh`, `check-version.sh`)
- **Zip file**: Must match directory name exactly: `{skill-name}.zip`

### SKILL.md Format

```markdown
---
name: {skill-name}
description: {One sentence describing when to use this skill. Include trigger phrases and use cases.}
---

## Links

{Official documentation and reference links}

## Quick Start

{Installation and setup instructions}

## Key Concepts

{Core understanding needed to use this skill}

## Code Examples

{Working examples with best practices}

## Best Practices

{Production recommendations}

## Troubleshooting

{Common issues and solutions}
```

### Best Practices for Context Efficiency

Skills are loaded on-demand — only the skill name and description are loaded at startup. The full `SKILL.md` loads into context only when the agent decides the skill is relevant. To minimize context usage:

- **Keep SKILL.md under 500 lines** — put detailed reference material in separate files
- **Write specific descriptions** — helps the agent know exactly when to activate the skill
- **Use progressive disclosure** — reference supporting files that get read only when needed
- **Prefer scripts over inline code** — script execution doesn't consume context (only output does)
- **File references work one level deep** — link directly from SKILL.md to supporting files

### End-User Installation

Document these installation methods for users:

**Claude Code:**
```bash
cp -r skills/{skill-name} ~/.claude/skills/
```

**GitHub Copilot (VS Code):**
Copy the skill folder to `.github/skills/` or `.vscode/skills/` in your project.

**claude.ai:**
Add the skill to project knowledge or paste SKILL.md contents into the conversation.

## Contributing

1. Fork the repository
2. Create a new skill folder in `skills/`
3. Add a `SKILL.md` following the format above
4. Test with your preferred AI agent
5. Submit a pull request