# Resend Integration Skill

This skill enables AI coding agents to integrate with Resend's email service via Model Context Protocol (MCP). Supports **GitHub Copilot Coding Agent** (recommended for teams), VS Code, Claude Desktop, and Cursor.

## What This Skill Provides

- **GitHub Copilot Coding Agent**: Repository-level email automation for teams
- **MCP Server Integration**: Local Node.js MCP server that exposes Resend email functionality
- **Multi-Platform Support**: Works with GitHub Copilot (Coding Agent), VS Code Insider, Claude Desktop, Cursor, and other MCP-compatible clients
- **Natural Language Email Sending**: Ask your AI agent to send emails in plain English
- **Configuration Guides**: Step-by-step setup for all supported platforms
- **Security Best Practices**: API key management via GitHub Actions secrets for teams, environment variables for individuals
- **Real-World Examples**: Practical patterns for transactional, marketing, and notification emails

## Quick Links

- [SKILL.md](SKILL.md) - Complete skill documentation (start here)
- [CONFIGURATION.md](references/CONFIGURATION.md) - Detailed configuration for all clients
- [EXAMPLES.md](references/EXAMPLES.md) - Real-world usage examples
- [setup-resend-mcp.sh](scripts/setup-resend-mcp.sh) - Automated setup script (Linux/macOS)

## Installation

### Option 1: Automated Setup (Recommended)

```bash
chmod +x scripts/setup-resend-mcp.sh
./scripts/setup-resend-mcp.sh
```

This script will:
1. Clone the Resend MCP server
2. Install dependencies
3. Build the project
4. Generate configuration examples
5. Create `.env.local` with your API key

### Option 2: Manual Setup

See [SKILL.md - Quick Start](SKILL.md#quick-start) section.

## Getting Started

### 1. Get API Key
Visit https://resend.com/api-keys and create a new API key.

### 2. Choose Your Setup

**GitHub Copilot Coding Agent (Recommended for Teams):**
- Repository admin configures MCP in GitHub settings
- Secrets managed via GitHub Actions
- See [CONFIGURATION.md](references/CONFIGURATION.md#github-copilot-coding-agent-repository-level)

**GitHub Copilot in VS Code (Local Development):**
- Create `.vscode/mcp.json` in your project
- See [CONFIGURATION.md](references/CONFIGURATION.md#github-copilot-in-vs-code-insider-local-development)

**Claude Desktop:**
- Edit your Claude config file
- See [CONFIGURATION.md](references/CONFIGURATION.md#claude-desktop)

**Cursor:**
- Open Cursor Settings → MCP
- See [CONFIGURATION.md](references/CONFIGURATION.md#cursor-agent-mode)

### 3. Test It

Ask your AI agent:
```
Send me a test email using Resend MCP
```

## Key Features

✅ **Send Emails via Natural Language**
```
Send an email to customer@example.com about their order using Resend MCP
```

✅ **HTML and Plain Text Support**
```
Create an HTML formatted welcome email with a button and send it via Resend MCP
```

✅ **CC/BCC Recipients**
```
Send email with CC to manager@company.com using Resend MCP
```

✅ **Scheduled Delivery**
```
Schedule an email to be sent tomorrow at 9 AM using Resend MCP
```

✅ **Broadcast to Audiences** (New)
```
Send a broadcast email to the 'premium_users' audience using Resend MCP
```

✅ **Audience Management** (New)
```
List all my audiences in Resend and send targeted emails
```

✅ **Personalized Batch Sending**
```
Read the CSV file and send personalized emails to each recipient using Resend MCP
```

✅ **Integration Workflows**
```
Process the order and send confirmation email using Resend MCP
```

## Security

- API keys stored in environment variables, not in code
- Support for `.env.local` and `.env` files (with `.gitignore`)
- Separate configurations for development vs. production
- No API keys committed to version control

See [SKILL.md - Best Practices](SKILL.md#best-practices) for details.

## Troubleshooting

Common issues and solutions are documented in [SKILL.md - Troubleshooting](SKILL.md#troubleshooting).

### Quick Checks

1. **Is Node.js installed?**
   ```bash
   node --version
   ```

2. **Is the MCP server built?**
   ```bash
   ls mcp-send-email/build/index.js
   ```

3. **Is the API key valid?**
   - Check key starts with `re_`
   - Generate new key at https://resend.com/api-keys

4. **Is the tool showing in your IDE?**
   - Reload VS Code / Restart Cursor / Close and reopen Claude Desktop
   - Check configuration file syntax (valid JSON)

## Documentation Structure

```
resend-integration-skills/
├── SKILL.md                           # Main skill documentation
├── README.md                          # This file
├── scripts/
│   └── setup-resend-mcp.sh           # Automated setup script
└── references/
    ├── CONFIGURATION.md              # Configuration for all clients
    └── EXAMPLES.md                   # Real-world usage examples
```

## Platform Support

| Platform | Type | Support | Setup Location |
|----------|------|---------|----------------|
| **GitHub Copilot Coding Agent** | Team (Repository) | ✅ Full | GitHub Settings → Copilot |
| **GitHub Copilot** (VS Code) | Individual (Local) | ✅ Full | `.vscode/mcp.json` |
| **Claude Desktop** | Individual (Local) | ✅ Full | Claude config file |
| **Cursor** | Individual (Local) | ✅ Full | Cursor Settings → MCP |
| **VS Code Standard** | Individual (Local) | ⚠️ Limited | See [SKILL.md](SKILL.md#issue-mcp-server-not-appearing-in-ide-tools-list) |

## Requirements

**For GitHub Copilot Coding Agent:**
- GitHub Copilot Enterprise or Pro (for Coding Agent)
- Repository administrator access
- Node.js 20+ in GitHub Actions runner
- Resend API key

**For Local Development (VS Code, Cursor, Claude):**
- Node.js 20 or higher (local)
- Resend account (free tier available)
- API key from https://resend.com/api-keys
- VS Code Insider (for GitHub Copilot) or Claude Desktop or Cursor

## License

This skill references and integrates with:
- [Resend](https://resend.com) - Email sending service
- [MCP Protocol](https://modelcontextprotocol.io/) - Open protocol standard
- [Resend MCP Server](https://github.com/resend/mcp-send-email) - Official Resend MCP implementation

## Support

For issues with:
- **Resend Service**: https://support.resend.com
- **MCP Protocol**: https://modelcontextprotocol.io
- **VS Code Insider**: https://github.com/microsoft/vscode
- **GitHub Copilot**: https://github.com/github-copilot
- **Cursor**: https://docs.cursor.com

## Quick Examples

Quick examples:

```
1. Simple email:
   "Send a test email to john@example.com"

2. Formatted email:
   "Create a professional HTML email with a table showing sales data and send it to team@example.com"

3. Using email.md (official test pattern):
   Create email.md file, select all, press Cmd+L/Ctrl+L, say "send this email"

4. Batch emails:
   "Read customers.csv and send personalized emails to each customer"

5. Broadcast to audience:
   "Send a broadcast email to the 'premium_users' audience using Resend MCP"

6. Marketing email:
   "Generate and send a newsletter to subscribers using Resend MCP"

7. Notification:
   "Send an order confirmation email to the customer with order details"
```

See [EXAMPLES.md](references/EXAMPLES.md) for more detailed examples.

---

**Ready to start?** See [SKILL.md - Quick Start](SKILL.md#quick-start)
