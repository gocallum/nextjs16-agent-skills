# COPILOT.md

Instructions for using these Agent Skills with GitHub Copilot.

For contribution guidelines, see [AGENTS.md](AGENTS.md). For Claude-specific instructions, see [CLAUDE.md](CLAUDE.md).

## What are Agent Skills?

Agent Skills are folders of instructions, scripts, and resources that Copilot can load when relevant to improve its performance in specialized tasks. Agent Skills is an [open standard](https://github.com/agentskills/agentskills) used by a range of different agents.

## Compatibility

Agent Skills work with:

- **Copilot coding agent** - Available in GitHub repositories
- **GitHub Copilot CLI** - Command line interface (public preview)
- **VS Code Insiders** - Agent mode (stable VS Code support coming soon)

## Requirements

- GitHub Copilot Pro, Pro+, Business, or Enterprise plan
- Skills must contain a `SKILL.md` file with YAML frontmatter
- Skill directory names: lowercase, hyphens for spaces

## Installation

### Project Skills (Repository-Specific)

Store skills in your repository's `.github/skills/` folder:

```bash
# Clone this repository
git clone https://github.com/gocallum/nextjs16-agent-skills.git

# In your project root, create the skills directory
mkdir -p .github/skills

# Copy a specific skill
cp -r nextjs16-agent-skills/skills/nextjs16-skills .github/skills/

# Or copy all skills
cp -r nextjs16-agent-skills/skills/* .github/skills/
```

**Alternative location**: `.claude/skills/` is also supported for project skills.

### Personal Skills (Shared Across Projects)

Store skills in your home directory for use across all projects:

```bash
# Copy to personal Copilot skills directory
cp -r nextjs16-agent-skills/skills/* ~/.copilot/skills/

# Or use the Claude skills directory (also supported)
cp -r nextjs16-agent-skills/skills/* ~/.claude/skills/
```

**Note**: Personal skills are only available with Copilot coding agent and GitHub Copilot CLI.

## Skill Structure

Each skill must have this structure:

```
.github/skills/
  {skill-name}/           # Lowercase, hyphens for spaces
    SKILL.md              # Required: must be named exactly SKILL.md
    scripts/              # Optional: helper scripts
    examples/             # Optional: example files
    references/           # Optional: additional documentation
```

### SKILL.md Format

```markdown
---
name: skill-name
description: What this skill does and when Copilot should use it.
license: MIT
---

# Skill Title

Instructions, examples, and guidelines for Copilot to follow.

## How to Use

Step-by-step instructions...

## Examples

Concrete examples...
```

### Field Requirements

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier. Lowercase, hyphens for spaces. Should match directory name. |
| `description` | Yes | What the skill does AND when Copilot should use it. |
| `license` | No | License that applies to this skill. |

## How Copilot Uses Skills

1. **Discovery**: Copilot reads skill metadata (`name` and `description`) at startup
2. **Matching**: When you make a request, Copilot matches it against skill descriptions
3. **Loading**: When relevant, `SKILL.md` is injected into Copilot's context
4. **Execution**: Copilot follows the instructions and can use bundled scripts/resources

## Skills vs Custom Instructions

| Feature | Skills | Custom Instructions |
|---------|--------|---------------------|
| **Scope** | Loaded on-demand when relevant | Always loaded for every task |
| **Use case** | Detailed, specialized tasks | Simple, universal guidelines |
| **Example** | "Debug GitHub Actions workflows" | "Use TypeScript, prefer pnpm" |

**Recommendation**: Use custom instructions for coding standards that apply everywhere. Use skills for detailed workflows Copilot should access only when relevant.

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
   mkdir -p .github/skills
   ```

2. Copy a skill:
   ```bash
   cp -r /path/to/nextjs16-agent-skills/skills/nextjs16-skills .github/skills/
   ```

3. Commit to your repository:
   ```bash
   git add .github/skills
   git commit -m "Add Next.js 16 agent skill"
   ```

4. Use Copilot as normal—it will automatically use the skill when relevant to your request.

## Resources

- [About Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- [Agent Skills Open Standard](https://github.com/agentskills/agentskills)
- [Anthropic Skills Repository](https://github.com/anthropics/skills)
- [Awesome Copilot Collection](https://github.com/github/awesome-copilot)
- [Repository Custom Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions)
