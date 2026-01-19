# Resend MCP Configuration Reference

This file contains complete configuration examples for all supported clients and environments.

## GitHub Copilot Coding Agent (Repository-level)

### Setup Steps

This is the official GitHub Copilot recommended approach for team collaboration.

**Prerequisites:**
- Repository administrator access
- GitHub Copilot Enterprise or Pro (for Coding Agent feature)
- Node.js 20+ in the GitHub Actions runner

**Step 1: Navigate to Repository MCP Settings**

1. Go to your GitHub repository on GitHub.com
2. Click Settings → Copilot → Coding agent
3. Scroll to "MCP configuration section"

**Step 2: Add Resend MCP Configuration**

In the MCP configuration section, add:

```json
{
  "mcpServers": {
    "resend": {
      "type": "local",
      "command": "node",
      "args": ["/absolute/path/to/mcp-send-email/build/index.js"],
      "env": {
        "RESEND_API_KEY": "COPILOT_MCP_RESEND_API_KEY"
      },
      "tools": ["send_email", "schedule_email"]
    }
  }
}
```

**Important differences from VS Code:**
- Use `type: "local"` (not `type: "command"`)
- Reference secrets by name, not value: `"COPILOT_MCP_RESEND_API_KEY"` (not the actual API key)
- Include required `tools` array specifying which tools to enable
- GitHub automatically passes the secret value to the server

**Step 3: Set Up Copilot Environment**

1. Go to Settings → Environments
2. Click "New environment"
3. Name it `copilot` and click "Configure environment"
4. Under "Environment secrets", click "Add environment secret"
5. Create secret with:
   - Name: `COPILOT_MCP_RESEND_API_KEY`
   - Value: Your actual Resend API key (e.g., `re_xxxxxxxxxxxx`)
   - Click "Add secret"

**Step 4: Save Configuration**

Click "Save" in the MCP configuration section. GitHub will validate the JSON syntax.

### Tools Available

Specify which Resend tools Copilot can use:

```json
{
  "tools": [
    "send_email",           // Send individual emails
    "schedule_email",       // Schedule emails for future delivery
    "list_audiences",       // List available audiences
    "send_broadcast_email"  // Send broadcast to audience segment
  ]
}
```

Or enable all tools:
```json
{
  "tools": ["*"]
}
```

### Validation and Testing

After configuration:

1. Create a test issue in the repository
2. Assign it to Copilot
3. Copilot will react with 👀 emoji
4. Copilot will create a PR with proposed changes
5. In the PR timeline, wait for "Copilot started work" event
6. Click "View session" to see MCP server logs
7. Expand "Start MCP Servers" step to verify Resend tools loaded

### Full Configuration Example

```json
{
  "mcpServers": {
    "resend": {
      "type": "local",
      "command": "node",
      "args": ["/home/runner/mcp-send-email/build/index.js"],
      "env": {
        "RESEND_API_KEY": "COPILOT_MCP_RESEND_API_KEY",
        "SENDER_EMAIL_ADDRESS": "noreply@company.com"
      },
      "tools": ["send_email", "schedule_email", "send_broadcast_email"]
    }
  }
}
```

---

## GitHub Copilot in VS Code Insider (Local Development)

### Minimal Configuration

Create `.vscode/mcp.json` in your project root:

```json
{
  "servers": {
    "resend": {
      "type": "command",
      "command": "node /absolute/path/to/mcp-send-email/build/index.js",
      "env": {
        "RESEND_API_KEY": "re_xxxxxxxxxxxx"
      }
    }
  }
}
```

**Important**: Node.js 20+ must be installed and in your PATH:
```bash
node --version  # Should output v20.x.x or higher
```

### Full Configuration with All Options

```json
{
  "servers": {
    "resend": {
      "type": "command",
      "command": "node",
      "args": ["/absolute/path/to/mcp-send-email/build/index.js"],
      "env": {
        "RESEND_API_KEY": "re_xxxxxxxxxxxx",
        "SENDER_EMAIL_ADDRESS": "onboarding@example.com",
        "REPLY_TO_EMAIL_ADDRESS": "reply@example.com"
      }
    }
  }
}
```

---

## Cursor Agent Mode

### Quick Setup

```json
{
  "mcpServers": {
    "resend": {
      "type": "command",
      "command": "node /absolute/path/to/mcp-send-email/build/index.js --key=re_xxxxxxxxxxxx"
    }
  }
}
```

### With All Options

```json
{
  "mcpServers": {
    "resend": {
      "type": "command",
      "command": "node /absolute/path/to/mcp-send-email/build/index.js --key=re_xxxxxxxxxxxx --sender=onboarding@example.com --reply-to=reply@example.com"
    }
  }
}
```

---

## Claude Desktop

### macOS Configuration Location

`~/Library/Application Support/Claude/claude_desktop_config.json`

### Windows Configuration Location

`%APPDATA%\Claude\claude_desktop_config.json`

### Quick Setup

```json
{
  "mcpServers": {
    "resend": {
      "command": "node",
      "args": ["/absolute/path/to/mcp-send-email/build/index.js"],
      "env": {
        "RESEND_API_KEY": "re_xxxxxxxxxxxx"
      }
    }
  }
}
```

---

## Configuration Comparison

| Aspect | Coding Agent | VS Code | Cursor | Claude |
|--------|--------------|---------|--------|--------|
| **Type** | `local` | `command` | `command` | stdio |
| **Location** | GitHub Settings | `.vscode/mcp.json` | Cursor Settings | Config file |
| **Secrets** | GitHub Actions (`COPILOT_MCP_*`) | Environment vars | Arguments | Env vars |
| **Tools** | Required ✅ | N/A | N/A | N/A |
| **Approval** | Autonomous ⚠️ | N/A | N/A | N/A |
| **Team Setup** | Yes (admin) | Developer-only | Developer-only | Developer-only |

### Key Differences

**GitHub Copilot Coding Agent:**
- Repository-level configuration (admin controls)
- Requires explicit `tools` array
- Uses GitHub Actions secrets
- Autonomous execution without approval

**VS Code / Cursor / Claude:**
- Local/individual developer setup
- Direct API key configuration
- Inline arguments or environment variables
- Developer discretion

---

## Testing Configuration with email.md

The official Resend repository includes a test pattern using markdown files. Create an `email.md` in your project:

```markdown
to: your-email@example.com
subject: Test Email
content: Hello from Resend MCP

This is a test email using the email.md pattern.

# Optional CC and BCC:
# cc: colleague@example.com
# bcc: manager@example.com
```

### Testing in Cursor

1. Open the `email.md` file
2. Select all text (`Cmd+A` or `Ctrl+A`)
3. Press `Cmd+L` or `Ctrl+L`
4. Tell Cursor: "send this as an email" or "send this email using resend"
5. Ensure Agent mode is enabled (check the dropdown in chat)

### Testing in Claude Desktop

1. Copy the email.md content into a chat
2. Ask Claude: "Send this email using the resend tool"
3. Claude will parse the format and send via the MCP tool

### Testing in GitHub Copilot

1. Open the `email.md` file
2. Reference it in chat: `@email.md send this email using resend`
3. Ensure you're in Agent mode

This pattern is useful because:
- **Natural format**: Easy to read and edit
- **File-based**: Can be committed to version control (with test addresses)
- **Agent-friendly**: LLMs understand the structured format
- **Quick testing**: Verify MCP setup without complex prompts

---

## Environment Variables Reference

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `RESEND_API_KEY` | Yes | Your Resend API key | `re_xxxxxxxxxxxx` |
| `SENDER_EMAIL_ADDRESS` | No | Verified sender email | `onboarding@example.com` |
| `REPLY_TO_EMAIL_ADDRESS` | No | Reply-to email address | `reply@example.com` |

---

## Troubleshooting

### Coding Agent: MCP Server Not Loading

1. Verify JSON syntax: Use a JSON validator to check your configuration
2. Check tool names: Use actual tool names from the server (not made up names)
3. Verify secrets: Ensure secrets begin with `COPILOT_MCP_` prefix
4. Check logs: Create test issue → Check "View session" → Look for "Start MCP Servers" step

### VS Code / Cursor / Claude: MCP Server Not Found

1. Verify path: Check that absolute path to `build/index.js` is correct
2. Verify Node.js: Ensure Node.js 20+ is installed and in PATH
3. Test directly: Run `node /path/to/build/index.js` to verify it works
4. Restart IDE: Close and reopen VS Code / Cursor / Claude completely

### API Key Issues

| Error | Solution |
|-------|----------|
| `Unauthorized` | Generate new API key from https://resend.com/api-keys |
| `Invalid sender` | Verify sender domain at https://resend.com/domains |
| `Key not found` | Check environment variable name matches exactly |

---

## Multi-Client Setup

To use Resend MCP with both GitHub Copilot Coding Agent and local development:

1. Build MCP server once (see Quick Start in SKILL.md)
2. Configure Coding Agent (use GitHub Settings)
3. Configure VS Code (create `.vscode/mcp.json`)

Both will use the same `build/index.js` file.

---

## Advanced: HTTP Server Configuration

For shared/remote setups:

```json
{
  "servers": {
    "resend": {
      "type": "http",
      "url": "https://mcp-resend.company.com/mcp"
    }
  }
}
```

The HTTP server should proxy requests to the local Node.js MCP server.

---

## References

- [GitHub Copilot Coding Agent Documentation](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/extend-coding-agent-with-mcp)
- [VS Code MCP Documentation](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)
- [Resend MCP Repository](https://github.com/resend/mcp-send-email)
- [MCP Protocol Specification](https://modelcontextprotocol.io)
