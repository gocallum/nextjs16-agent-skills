#!/bin/bash

# Setup Resend MCP Server for GitHub Copilot and Claude Desktop
# This script automates the setup process for Resend email integration

set -e

echo "=== Resend MCP Server Setup ==="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed."
    echo "Please install Node.js from https://nodejs.org (LTS recommended)"
    exit 1
fi

NODE_VERSION=$(node --version)
echo "✓ Node.js $NODE_VERSION found"

# Prompt for directory to clone into
read -p "Enter directory to clone Resend MCP server (default: ./mcp-send-email): " CLONE_DIR
CLONE_DIR=${CLONE_DIR:=./mcp-send-email}

# Clone repository
echo ""
echo "Cloning Resend MCP repository..."
if [ -d "$CLONE_DIR" ]; then
    echo "⚠️  Directory already exists. Skipping clone."
else
    git clone https://github.com/resend/mcp-send-email.git "$CLONE_DIR"
fi

cd "$CLONE_DIR"

# Install dependencies
echo ""
echo "Installing dependencies..."
npm install

# Build the project
echo ""
echo "Building MCP server..."
npm run build

# Get absolute path
ABSOLUTE_PATH=$(cd build && pwd)
echo ""
echo "✓ Build successful!"
echo ""
echo "MCP server built at: $ABSOLUTE_PATH"

# Prompt for API key
echo ""
read -sp "Enter your Resend API key (from https://resend.com/api-keys): " RESEND_API_KEY
echo ""

# Ask for sender email
echo ""
read -p "Enter sender email (optional, press Enter to skip): " SENDER_EMAIL
echo ""

# Ask for reply-to email
read -p "Enter reply-to email (optional, press Enter to skip): " REPLY_TO_EMAIL
echo ""

# Generate .env.local file
echo "Generating .env.local file..."
cat > .env.local << EOF
RESEND_API_KEY=$RESEND_API_KEY
EOF

if [ -n "$SENDER_EMAIL" ]; then
    echo "SENDER_EMAIL_ADDRESS=$SENDER_EMAIL" >> .env.local
fi

if [ -n "$REPLY_TO_EMAIL" ]; then
    echo "REPLY_TO_EMAIL_ADDRESS=$REPLY_TO_EMAIL" >> .env.local
fi

echo "✓ .env.local created (added to .gitignore)"

# Add to .gitignore
if ! grep -q ".env.local" .gitignore 2>/dev/null; then
    echo ".env.local" >> .gitignore
fi

# Display configuration for VS Code Insider
echo ""
echo "=== GitHub Copilot Configuration (VS Code Insider) ==="
echo ""
echo "Create .vscode/mcp.json in your project:"
echo ""
cat << EOF
{
  "servers": {
    "resend": {
      "type": "command",
      "command": "node",
      "args": ["$ABSOLUTE_PATH/index.js"],
      "env": {
        "RESEND_API_KEY": "$RESEND_API_KEY"
EOF

if [ -n "$SENDER_EMAIL" ]; then
    echo "        \"SENDER_EMAIL_ADDRESS\": \"$SENDER_EMAIL\","
fi

if [ -n "$REPLY_TO_EMAIL" ]; then
    echo "        \"REPLY_TO_EMAIL_ADDRESS\": \"$REPLY_TO_EMAIL\""
else
    echo "      }"
fi

cat << EOF
      }
    }
  }
}
EOF

echo ""
echo "=== Claude Desktop Configuration ==="
echo ""
echo "Edit your Claude Desktop config:"
echo "macOS: ~/Library/Application Support/Claude/claude_desktop_config.json"
echo "Windows: %APPDATA%\\Claude\\claude_desktop_config.json"
echo ""
echo "Add this to mcpServers:"
cat << EOF
{
  "mcpServers": {
    "resend": {
      "command": "node",
      "args": ["$ABSOLUTE_PATH/index.js"],
      "env": {
        "RESEND_API_KEY": "$RESEND_API_KEY"
EOF

if [ -n "$SENDER_EMAIL" ]; then
    echo "        \"SENDER_EMAIL_ADDRESS\": \"$SENDER_EMAIL\","
fi

if [ -n "$REPLY_TO_EMAIL" ]; then
    echo "        \"REPLY_TO_EMAIL_ADDRESS\": \"$REPLY_TO_EMAIL\""
fi

cat << EOF
      }
    }
  }
}
EOF

echo ""
echo "✓ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Copy the configuration above to your IDE settings"
echo "2. Restart your IDE"
echo "3. Test by asking: 'Send me an email using Resend MCP'"
echo ""
