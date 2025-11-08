#!/bin/bash

# Only run in Claude Code remote sessions
if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

echo "Setting up mise for Claude Code remote session..."

# Install mise if not already installed
if ! command -v mise &> /dev/null; then
  echo "Installing mise..."
  curl -sSf https://mise.run | sh

  # Add mise to PATH for this script
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "mise already installed"
fi

# Verify mise is available
if ! command -v mise &> /dev/null; then
  echo "Error: mise installation failed or not in PATH"
  exit 1
fi

# Install tools defined in .tool-versions
echo "Installing tools from .tool-versions..."
mise install

# Persist mise environment for the entire session
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo "Setting up mise environment for session..."
  # Add mise to PATH
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$CLAUDE_ENV_FILE"
  # Export mise-managed tool paths and environment
  mise hook-env >> "$CLAUDE_ENV_FILE"
fi

echo "mise setup complete!"
