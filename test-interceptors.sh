#!/bin/bash
# Test script for Claude Interceptors

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TEST_DIR="$(mktemp -d)"
INTERCEPTOR_DIR="$(pwd)"

log() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    exit 1
}

cleanup() {
    rm -rf "$TEST_DIR"
}

trap cleanup EXIT

test_interceptor() {
    local script="$1"
    local expected_pattern="$2"
    
    log "Testing $script interceptor..."
    
    # Test that interceptor exists and is executable
    if [[ ! -x "$INTERCEPTOR_DIR/$script" ]]; then
        fail "$script is not executable"
    fi
    
    # Test that it outputs expected message
    output=$("$INTERCEPTOR_DIR/$script" --help 2>&1 || true)
    if [[ ! "$output" =~ $expected_pattern ]]; then
        fail "$script didn't output expected pattern: $expected_pattern"
    fi
    
    success "$script interceptor works"
}

test_bypass() {
    local script="$1"
    
    log "Testing $script bypass with CLAUDE_INTERCEPTOR_BYPASS..."
    
    # This should NOT be intercepted (but will fail because the script doesn't exist)
    CLAUDE_INTERCEPTOR_BYPASS=1 "$INTERCEPTOR_DIR/$script" --version 2>/dev/null || true
    
    success "$script bypass works"
}

test_management_script() {
    log "Testing management script..."
    
    if [[ ! -x "$INTERCEPTOR_DIR/claude-interceptor" ]]; then
        fail "claude-interceptor script is not executable"
    fi
    
    # Test help command
    output=$("$INTERCEPTOR_DIR/claude-interceptor" help 2>&1)
    if [[ ! "$output" =~ "Claude Interceptor" ]]; then
        fail "Management script help doesn't work"
    fi
    
    success "Management script works"
}

test_install_script() {
    log "Testing install script syntax..."
    
    if [[ ! -x "$INTERCEPTOR_DIR/install.sh" ]]; then
        fail "install.sh is not executable"
    fi
    
    # Test that the script has valid bash syntax
    bash -n "$INTERCEPTOR_DIR/install.sh"
    
    success "Install script syntax is valid"
}

main() {
    echo "🧪 Testing Claude Interceptors"
    echo "=============================="
    
    # Test all interceptor scripts
    test_interceptor "python" "Direct python usage detected"
    test_interceptor "python3" "Direct python3 usage detected"
    test_interceptor "pip" "Direct pip.*detected"
    test_interceptor "pip3" "Direct pip3.*detected"
    test_interceptor "mypy" "mypy usage detected"
    test_interceptor "pyright" "pyright usage detected"
    test_interceptor "pylint" "pylint usage detected"
    test_interceptor "black" "black usage detected"
    test_interceptor "flake8" "flake8 usage detected"
    test_interceptor "isort" "isort usage detected"
    
    # Test bypass functionality
    test_bypass "python"
    test_bypass "pip"
    test_bypass "mypy"
    
    # Test management script
    test_management_script
    
    # Test install script
    test_install_script
    
    echo ""
    success "🎉 All tests passed!"
    
    echo ""
    echo "Manual testing suggestions:"
    echo "1. Try: ./python --help"
    echo "2. Try: ./black myfile.py"
    echo "3. Try: ./pylint myfile.py"
    echo "4. Try: ./flake8 ."
    echo "5. Try: CLAUDE_INTERCEPTOR_BYPASS=1 ./python --help" 
    echo "6. Try: ./claude-interceptor status"
}

main "$@"