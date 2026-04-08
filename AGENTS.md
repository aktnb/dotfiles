# Repository Guidelines

## Project Structure & Module Organization
This repository manages personal dotfiles and setup scripts for macOS and Linux. `install.sh` is the entry point and handles package installation plus symlink setup. Put shell, editor, and terminal configs under `config/`:

- `config/zsh/` for Zsh, Sheldon, Powerlevel10k, aliases, and local env hooks
- `config/nvim/` for Neovim (`init.lua`, `lua/`, `ftplugin/`, `lazy-lock.json`)
- `config/git/`, `config/ghostty/`, and `config/iterm2/` for tool-specific settings
- `bin/` for small helper scripts such as `df-links` and `df-unlink`

Keep new files grouped by tool, and preserve the existing symlink target layout used by `install.sh`.

## Build, Test, and Development Commands
There is no build step. Use these commands to validate changes:

- `./install.sh` installs packages and refreshes symlinks
- `./install.sh --private` includes optional private overlays when present
- `brew bundle --file=./Brewfile` applies macOS package changes without a full install
- `nvim --headless "+Lazy! sync" +qa` verifies Neovim plugin config loads cleanly
- `zsh -n config/zsh/.zshrc` checks shell syntax
- `bash -n install.sh` checks installer syntax

## Coding Style & Naming Conventions
Shell scripts use `bash` with `set -euo pipefail`; keep functions small and prefer lowercase snake_case names such as `setup_symlinks`. Neovim Lua modules use lowercase file names under `config/nvim/lua/` and are required from `init.lua`. Preserve existing indentation per file: two spaces are common in shell conditionals here, while Lua files currently use concise module-style formatting. Avoid embedding machine-specific secrets; use optional local files like `lsp_servers_local.lua` or private overlays instead.

## Testing Guidelines
This repo has no formal test framework or coverage gate. For every change, run the relevant syntax check plus one behavioral check:

- shell changes: `bash -n install.sh` and, if applicable, `zsh -n config/zsh/.zshrc`
- Neovim changes: `nvim --headless "+checkhealth" +qa` or a targeted startup check
- symlink changes: `./bin/df-links`

## Commit & Pull Request Guidelines
Recent history follows short, imperative subjects with prefixes like `feat:` and `change:`. Keep commits focused, for example `feat: add ghostty config symlink`. PRs should describe the affected tool, note OS scope (`macOS`, `Linux`, or both), list manual verification commands, and include screenshots only for terminal UI changes such as iTerm2 or Ghostty appearance updates.
