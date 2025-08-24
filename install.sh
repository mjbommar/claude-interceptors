#!/bin/bash
# Claude Interceptors - Simple One-Line Install

set -e
REPO_URL="https://raw.githubusercontent.com/mjbommar/claude-interceptors/master"
INSTALL_DIR="$HOME/.local/bin"

echo "🚀 Installing Claude Interceptors..."

# Check dependencies
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo "❌ Error: Need curl or wget to install" >&2
    exit 1
fi

# Create directory and download management script
mkdir -p "$INSTALL_DIR"

if command -v curl >/dev/null 2>&1; then
    curl -sSL "$REPO_URL/claude-interceptor" -o "$INSTALL_DIR/claude-interceptor"
else
    wget -q "$REPO_URL/claude-interceptor" -O "$INSTALL_DIR/claude-interceptor"
fi

chmod +x "$INSTALL_DIR/claude-interceptor"

# Run the install
"$INSTALL_DIR/claude-interceptor" install

# Add convenient aliases to ~/.bashrc
BASHRC="$HOME/.bashrc"
if [[ -f "$BASHRC" ]]; then
    # Remove existing aliases if they exist
    grep -v "claude-interceptor-" "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
    
    # Add new aliases
    cat >> "$BASHRC" << 'EOF'

# Claude Interceptor aliases
alias claude-interceptor-enable='source <(claude-interceptor enable)'
alias claude-interceptor-disable='source <(claude-interceptor disable)'
alias claude-interceptor-status='claude-interceptor status'
EOF
    echo "✅ Added aliases to ~/.bashrc"
fi

echo ""
echo "✅ Installed! Interceptors are ready but disabled by default."
echo ""
echo -e "\033[1;33m🔄 IMPORTANT: Run this command to enable aliases:\033[0m"
echo -e "\033[1;36m   source ~/.bashrc\033[0m"
echo ""
echo "Then you can use:"
echo "Enable for current session: claude-interceptor-enable"
echo "Disable for current session: claude-interceptor-disable" 
echo "Check status: claude-interceptor-status"
echo ""
echo "Test (after enabling): python --help (or black --help, pylint --help, etc.)"
echo "Bypass: python --help --force"
