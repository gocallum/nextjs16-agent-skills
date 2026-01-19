# CLAUDE.md

Instructions for using these Agent Skills with Claude Code and Claude.ai.

For contribution guidelines and skill authoring, see [AGENTS.md](AGENTS.md).

## What are Agent Skills?

Agent Skills are modular capabilities that extend Claude's functionality. Each Skill packages instructions, metadata, and optional resources (scripts, templates) that Claude uses automatically when relevant. Skills are loaded on-demand to minimize context usage.

## Using Skills with Claude Code

### Installation

Claude Code supports custom Skills through filesystem-based directories. Skills can be installed in two locations:

**Personal Skills** (available in all projects):
```bash
# Clone this repository
git clone https://github.com/gocallum/nextjs16-agent-skills.git

# Copy all skills to your personal Claude skills directory
cp -r nextjs16-agent-skills/skills/* ~/.claude/skills/

# Or copy a specific skill
cp -r nextjs16-agent-skills/skills/nextjs16-skills ~/.claude/skills/
```

**Project Skills** (available only in specific project):
```bash
# In your project root
mkdir -p .claude/skills

# Copy skills into your project
cp -r /path/to/nextjs16-agent-skills/skills/* .claude/skills/
```

### Requirements

- **Claude Code**: Skills are automatically discovered from `~/.claude/skills/` (personal) or `.claude/skills/` (project)
- **SKILL.md**: Each skill directory must contain a `SKILL.md` file with YAML frontmatter
- **Frontmatter**: Must include `name` and `description` fields

### SKILL.md Format

```markdown
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it.
---

# Your Skill Name

## Instructions
[Clear, step-by-step guidance for Claude to follow]

## Examples
[Concrete examples of using this Skill]
```

### Field Requirements

**name:**
- Maximum 64 characters
- Must contain only lowercase letters, numbers, and hyphens
- Cannot contain reserved words: "anthropic", "claude"

**description:**
- Must be non-empty
- Maximum 1024 characters
- Should include both what the Skill does AND when Claude should use it

## Using Skills with claude.ai

### Installation

1. Download the skill folder as a zip file
2. Go to [claude.ai](https://claude.ai) → Settings → Features
3. Upload the zip file under Custom Skills
4. Requires Pro, Max, Team, or Enterprise plan with code execution enabled

Alternatively, paste the contents of `SKILL.md` directly into Project Knowledge.

## How Skills Work

Skills use progressive disclosure to minimize context usage:

| Level | When Loaded | Context Cost | Content |
|-------|-------------|--------------|---------|
| **Metadata** | Always (at startup) | ~100 tokens per Skill | `name` and `description` from YAML frontmatter |
| **Instructions** | When Skill is triggered | Under 5k tokens | SKILL.md body with instructions and guidance |
| **Resources** | As needed | Effectively unlimited | Bundled files (scripts, templates, references) |

Claude automatically uses Skills when your request matches a Skill's description. Only relevant content is loaded into context.

## Best Practices

- **Keep SKILL.md under 500 lines** — put detailed reference material in separate files
- **Write specific descriptions** — helps Claude know exactly when to activate the skill
- **Use progressive disclosure** — reference supporting files that get read only when needed
- **Prefer scripts over inline code** — script execution doesn't consume context (only output does)

## Available Skills in This Repository

| Skill | Description |
|-------|-------------|
| `nextjs16-skills` | Next.js 16 breaking changes, Turbopack, async APIs |
| `prisma-orm-v7-skills` | Prisma ORM 7 upgrade guide, ESM-only, driver adapters |
| `ai-sdk-6-skills` | AI SDK 6 Beta, agents, tool approval, Groq, AI Gateway |
| `authjs-skills` | Auth.js v5 for Next.js authentication |
| `shadcn-skills` | shadcn/ui components, blocks, forms, theming |
| `upstash-vector-db-skills` | Vector DB, semantic search, RAG patterns |
| `mcp-server-skills` | MCP servers in Next.js with mcp-handler |
| `ba-prd-skills` | PRD Mastery for product requirements |
| `ai-agents-ui-skills` | ToolLoopAgent, AI SDK UI components |

## Resources

- [Agent Skills Overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Agent Skills Cookbook](https://platform.claude.com/cookbook/skills-notebooks-01-skills-introduction)
