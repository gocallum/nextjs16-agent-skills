# AI Agent Skills

A comprehensive collection of skills and guides for building intelligent AI agent applications using modern frameworks and tools.

**Status:** Open Source  
**Author:** [Callum Bir](https://github.com/gocallum)  
**Repository:** [gocallum/nextjs16-agent-skills](https://github.com/gocallum/nextjs16-agent-skills)

---

## Overview

This project provides a curated collection of skills focused on building production-ready AI agent applications. Each skill is a comprehensive guide that covers key facts, best practices, code examples, and architectural patterns for specific technologies.

## Motivation

This collection was created to provide up-to-date guidance and resources for modern web development and AI integration. The primary focus areas include:

- **Next.js 16 Migration** - Comprehensive documentation on upgrading to Next.js 16, including breaking changes, Turbopack bundler, and async request APIs
- **Prisma ORM v7** - In-depth coverage of Prisma's latest version with ESM-only support, driver adapters, and modern database patterns
- **Upstash Vector Database on Vercel** - Production-ready guidance for semantic search and AI applications using serverless vector databases

These tools form the foundation of modern full-stack applications and represent the current best practices for building scalable, AI-powered systems.

## Available Skills

### 🤖 AI & Agents

- **[AI Agents & UI Skills](./skills/ai-agents-ui-skills)** - Complete guide to building agentic applications with ToolLoopAgent, workflow patterns, and AI SDK UI components (useChat, generative UIs, tool calling)

- **[AI SDK 6 Skills](./skills/ai-sdk-6-skills)** - Comprehensive coverage of AI SDK 6 beta including agents, tool approval, structured output, reranking, Groq provider integration, and Vercel AI Gateway

- **[MCP Server Skills](./skills/mcp-server-skills)** - Next.js MCP server pattern using mcp-handler with shared Zod schemas, reusable server actions, and lightweight `app/api/[transport]/route.ts` handlers

### 🚀 Framework & Infrastructure

- **[Next.js 16 Skills](./skills/nextjs16-skills)** - Essential facts about Next.js 16 breaking changes, Turbopack bundler, async request APIs, and upgrade path

- **[Prisma ORM v7 Skills](./skills/prisma-orm-v7-skills)** - Prisma v7 breaking changes including ESM-only, driver adapters, new prisma.config.ts, and pnpm as default package manager

- **[Shadcn UI Skills](./.claude/skills/shadcn-skills/skills.md)** - Next.js-first shadcn/ui components, blocks, Sonner toasts, forms, theming, and MCP-powered agent workflows

### 🔐 Authentication & Security

- **[Auth.js Skills](./skills/authjs-skills)** - Complete Auth.js v5 guide for Next.js authentication including Google OAuth, credentials provider, session management, middleware, and security best practices

### 💾 Data & Storage

- **[Upstash Vector DB Skills](./skills/upstash-vector-db-skills)** - Serverless vector database guide covering semantic search, namespace isolation, MixBread embedding models, and Vercel deployment patterns

---

## Skill Structure

Each skill follows a consistent format:

```
skill-name/
├── skills.md          # Comprehensive skill guide
├── SKILL.MD          # (Alternative) Quick reference
```

### What's Included in Each Skill

- **Installation & Setup** - Step-by-step setup instructions
- **Key Concepts** - Core understanding and architecture
- **Configuration Options** - All available settings and options
- **Code Examples** - Working examples with best practices
- **Workflow Patterns** - Common patterns and use cases
- **Best Practices** - Production recommendations
- **Resources** - Links to official documentation

---

## Understanding Agent Skills

Agent Skills are reusable components that extend the capabilities of AI agents in VS Code and other development environments. They enable agents to perform specific tasks by providing structured knowledge about tools, frameworks, and best practices.

**How to Use These Skills:**

These skills are designed to be referenced by AI agents as they work on projects. When an agent encounters a task related to Next.js, Prisma, AI SDK, or vector databases, it can consult the relevant skill to understand best practices, configuration options, and implementation patterns. Each skill acts as a knowledge base that helps agents make informed decisions and generate production-ready code.

You can leverage these skills in several ways:

1. **In VS Code Copilot** - Reference these skills when working on agent-related tasks to get contextual guidance
2. **In Custom Agents** - Build your own agents that can reference these skills for specialized knowledge
3. **Documentation Reference** - Use as comprehensive guides when developing applications with these technologies
4. **Team Knowledge Base** - Share within your team to ensure consistent implementation patterns and best practices

The skills are structured to be both human-readable and machine-parseable, making them ideal for both developer reference and AI agent consumption.

---

## Getting Started

### Prerequisites

- Node.js 20.9+
- TypeScript 5+
- pnpm (recommended package manager)

### Using the Skills

Each skill is self-contained and can be used independently. Start with:

1. **Pick a skill** based on your use case
2. **Read the overview section** for context
3. **Follow the installation & setup** section
4. **Review code examples** in the skill guide for your specific scenario
5. **Reference best practices** section when building

---

## Technology Stack

The skills cover the following technologies and frameworks:

| Technology | Version | Status |
|-----------|---------|--------|
| Next.js | 16 | Latest |
| Prisma ORM | v7 | Latest |
| AI SDK | 6 (Beta) | Beta |
| TypeScript | 5+ | Latest |
| React | Latest | Latest |
| Vercel AI Gateway | Latest | Latest |
| Groq | Latest | Latest |
| Upstash Vector DB | Latest | Latest |

---

## Package Manager

**pnpm** is the recommended package manager for all projects in this collection. Use it to install dependencies, run development servers, and build for production.

---

## Key Features

✅ **Production-Ready Examples** - All code examples are tested and production-ready  
✅ **Best Practices** - Curated best practices for each technology  
✅ **Comprehensive Coverage** - In-depth guides from basics to advanced patterns  
✅ **Type-Safe** - Full TypeScript support throughout  
✅ **Up-to-Date** - Regular updates following latest releases  
✅ **Framework Agnostic** - Supports React, Vue, Svelte, Angular, and more  

---

## Contributing

Contributions are welcome! If you have improvements, bug fixes, or new skills to add:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-skill`)
3. Commit your changes (`git commit -m 'Add amazing skill'`)
4. Push to the branch (`git push origin feature/amazing-skill`)
5. Open a Pull Request

---

## License

This project is open source and available under the [MIT License](LICENSE).

---

## Resources

- **[VS Code Agent Skills Documentation](https://code.visualstudio.com/docs/copilot/customization/agent-skills)** - Official guide on creating and using agent skills
- **[AI SDK Documentation](https://v6.ai-sdk.dev/docs)** - Official AI SDK docs
- **[Next.js Documentation](https://nextjs.org/docs)** - Next.js official docs
- **[Prisma Documentation](https://www.prisma.io/docs)** - Prisma ORM docs
- **[Vercel AI Gateway](https://vercel.com/docs/ai-sdk-core/ai-gateway)** - AI Gateway docs
- **[Upstash Vector DB](https://upstash.com/docs/vector/overall/getstarted)** - Vector DB docs

---

## Author

**Callum Bir**

- GitHub: [@gocallum](https://github.com/gocallum)
- Repository: [nextjs16-agent-skills](https://github.com/gocallum/nextjs16-agent-skills)

---

## Support

If you find these skills helpful, please consider:

- ⭐ Starring the repository
- 🐛 Reporting issues
- 💬 Starting discussions
- 🤝 Contributing improvements

---

## Changelog

### v1.0.0 (December 2025)

**Initial Release**
- AI Agents & UI Skills
- AI SDK 6 Skills
- Next.js 16 Skills
- Prisma ORM v7 Skills
- Upstash Vector DB Skills

---

**Built with ❤️ by [Callum Bir](https://github.com/gocallum)**

Made with AI SDK, Next.js, and TypeScript
