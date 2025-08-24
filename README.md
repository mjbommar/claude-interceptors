# Claude Interceptors

**Simple Python Command Interceptor**

Intercepts old Python commands and suggests modern alternatives. Perfect for training AI agents and helping developers discover better tooling.

## 🚀 Quick Start

| Action | Command | Description |
|--------|---------|-------------|
| **Install** | `curl -sSL https://raw.githubusercontent.com/mjbommar/claude-interceptors/refs/heads/master/install.sh \| bash` | One-line install + adds aliases to ~/.bashrc |
| **Enable** | `claude-interceptor-enable` | Turn on for current session |
| **Test** | `python --help` | Should show interceptor message |
| **Disable** | `claude-interceptor-disable` | Turn off for current session |
| **Status** | `claude-interceptor-status` | Check installation status |
| **Bypass** | `python --help --force` | Skip interceptor temporarily |

> **Note**: After install, restart your terminal or run `source ~/.bashrc` to use the aliases.

## What It Does

When you (or an AI agent) run old Python commands, it shows better modern alternatives:

- `python script.py` → suggests `uv run script.py`
- `pip install pkg` → suggests `uv add pkg` or `uv pip install pkg`
- `mypy file.py` → suggests `ty file.py` (10x faster)
- `pyright .` → suggests `ty .` (no Node.js needed)
- `black file.py` → suggests `ruff format file.py` (10x faster)
- `pylint .` → suggests `ruff check .` (100x faster)
- `flake8 .` → suggests `ruff check .` (replaces entirely)
- `isort .` → suggests `ruff check --select I --fix .`

## Example

```bash
$ pip install requests
❌ Direct pip install detected!

🤖 AI Agent Instructions:
  Choose the right uv command for your use case:
  📦 uv add requests                    # Add to pyproject.toml dependencies
  📦 uv add --group dev requests        # Add to dev dependency group
  📦 uv add --group test requests       # Add to test dependency group
  📦 uv pip install requests            # Temporary install (no pyproject.toml change)

🔧 To proceed with pip anyway:
  pip install requests --force
  CLAUDE_INTERCEPTOR_BYPASS=1 pip install requests
```

## Management & Bypass

| Purpose | Command | Description |
|---------|---------|-------------|
| **Check Status** | `claude-interceptor-status` | Show installation and enable status |
| **Update** | `claude-interceptor update` | Update to latest version |
| **Uninstall** | `claude-interceptor uninstall` | Remove completely (cleans ~/.bashrc) |
| **Bypass Once** | `python script.py --force` | Skip interceptor for this command |
| **Bypass Once** | `CLAUDE_INTERCEPTOR_BYPASS=1 python script.py` | Environment variable bypass |

## Intercepted Commands

| Command | Suggests | Why |
|---------|----------|-----|
| `python script.py` | `uv run script.py` | Better dependency management |
| `pip install pkg` | `uv add pkg` / `uv pip install pkg` | Faster, more reliable |
| `mypy file.py` | `ty file.py` | 10-100x faster type checking |
| `pyright .` | `ty .` | Rust-based, no Node.js dependency |
| `black file.py` | `ruff format file.py` | 10-30x faster formatting |
| `pylint .` | `ruff check .` | 10-100x faster linting |
| `flake8 .` | `ruff check .` | Same rules, much faster |
| `isort .` | `ruff check --select I --fix .` | Built into ruff |

## Why Use This?

- **For AI Agents**: Provides clear guidance toward modern Python tooling
- **For Developers**: Learn about better tools as you work
- **For Teams**: Consistent tooling suggestions across projects
- **Safe**: Never breaks existing workflows, always allows bypass

## Uninstall

```bash
claude-interceptor uninstall
```

Removes everything cleanly.

## How It Works

1. Installs interceptor scripts to `~/.local/bin/claude-interceptors/`
2. Adds that directory to your PATH (before system commands)
3. When you run `python`/`pip`/etc, the interceptor runs instead
4. Shows suggestions and allows bypass to the real command

Simple, effective, and completely reversible.

## Inspiration

Inspired by the concept from [PyDevTools Blog: Interceptors](https://pydevtools.com/blog/interceptors/) - extended with more commands and better user experience.

---

**Made for better Python development workflows**
