# ANTIGRAVITY.md

Instructions for using these Agent Skills with Google Antigravity.

For contribution guidelines, see [AGENTS.md](AGENTS.md). For other agents, see [CLAUDE.md](CLAUDE.md) or [COPILOT.md](COPILOT.md).

## What are Agent Skills?

Skills are an [open standard](https://agentskills.io/) for extending agent capabilities. A skill is a folder containing a `SKILL.md` file with instructions that the agent can follow when working on specific tasks.

Each skill contains:
- Instructions for how to approach a specific type of task
- Best practices and conventions to follow
- Optional scripts and resources the agent can use

## Where Skills Live

Antigravity supports two types of skills:

| Location | Scope |
|----------|-------|
| `<workspace-root>/.agent/skills/<skill-folder>/` | Workspace-specific |
| `~/.gemini/antigravity/skills/<skill-folder>/` | Global (all workspaces) |

**Workspace skills** are great for project-specific workflows, like your team's deployment process or testing conventions.

**Global skills** work across all your projects. Use these for personal utilities or general-purpose tools you want everywhere.

## Installation

### Workspace Skills (Project-Specific)

Store skills in your project's `.agent/skills/` folder:

```bash
# Clone this repository
git clone https://github.com/gocallum/nextjs16-agent-skills.git

# In your project root, create the skills directory
mkdir -p .agent/skills

# Copy a specific skill
cp -r nextjs16-agent-skills/skills/nextjs16-skills .agent/skills/

# Or copy all skills
cp -r nextjs16-agent-skills/skills/* .agent/skills/
```

### Global Skills (All Workspaces)

Store skills in your home directory for use across all projects:

```bash
# Create the global skills directory
mkdir -p ~/.gemini/antigravity/skills

# Copy skills to global directory
cp -r nextjs16-agent-skills/skills/* ~/.gemini/antigravity/skills/
```

## Skill Structure

Each skill needs a `SKILL.md` file with YAML frontmatter:

```
.agent/skills/
└── my-skill/
    └── SKILL.md
```

You can include additional resources:

```
.agent/skills/my-skill/
├── SKILL.md       # Main instructions (required)
├── scripts/       # Helper scripts (optional)
├── examples/      # Reference implementations (optional)
└── resources/     # Templates and other assets (optional)
```

### SKILL.md Format

```markdown
---
name: my-skill
description: Helps with a specific task. Use when you need to do X or Y.
---

# My Skill

Detailed instructions for the agent go here.

## When to use this skill

- Use this when...
- This is helpful for...

## How to use it

Step-by-step guidance, conventions, and patterns the agent should follow.
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | A unique identifier for the skill (lowercase, hyphens for spaces). Defaults to folder name if not provided. |
| `description` | Yes | A clear description of what the skill does and when to use it. This is what the agent sees when deciding whether to apply the skill. |

**Tip**: Write your description in third person and include keywords that help the agent recognize when the skill is relevant.

## How the Agent Uses Skills

Skills follow a progressive disclosure pattern:

1. **Discovery**: When a conversation starts, the agent sees a list of available skills with their names and descriptions
2. **Activation**: If a skill looks relevant to your task, the agent reads the full `SKILL.md` content
3. **Execution**: The agent follows the skill's instructions while working on your task

You don't need to explicitly tell the agent to use a skill—it decides based on context. However, you can mention a skill by name if you want to ensure it's used.

## Best Practices

### Keep skills focused
Each skill should do one thing well. Instead of a "do everything" skill, create separate skills for distinct tasks.

### Write clear descriptions
The description is how the agent decides whether to use your skill. Make it specific about what the skill does and when it's useful.

### Use scripts as black boxes
If your skill includes scripts, encourage the agent to run them with `--help` first rather than reading the entire source code. This keeps the agent's context focused on the task.

### Include decision trees
For complex skills, add a section that helps the agent choose the right approach based on the situation.

## Available Skills

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

## Quick Start Example

1. Create the skills directory in your project:
   ```bash
   mkdir -p .agent/skills
   ```

2. Copy a skill:
   ```bash
   cp -r /path/to/nextjs16-agent-skills/skills/nextjs16-skills .agent/skills/
   ```

3. Start a conversation with Antigravity—it will automatically discover and use the skill when relevant to your request.

## Resources

- [Antigravity Skills Documentation](https://antigravity.google/docs/skills)
- [Agent Skills Open Standard](https://agentskills.io/)
- [Antigravity Agent Docs](https://antigravity.google/docs/agent)
