# Bootstrap Scripts

Automated installation and configuration scripts for development tools.

## Installation

1. Copy `env.example` to `.env` and configure variables:

   ```bash
   cp env.example .env
   ```

1. Edit `.env` file according to your settings

1. Run installation:

   ```bash
   ./main.sh
   ```

## Uninstallation

To completely remove all installed tools and configurations:

```bash
./main-uninstall.sh
```

### What the uninstall script does:

- **Removes installed packages** via appropriate package managers (apt, brew)
- **Removes version managers** (nvm, rust/cargo, gvm, bun)
- **Removes configurations** of all configured tools
- **Restores backups** of original configurations (if they existed)
- **Removes dotfiles** and associated symbolic links
- **Removes Docker** (if it was installed)
- **Resets shell** back to bash (if it was changed to zsh)

### Uninstall safety:

- Script creates backups of existing configurations before removal
- Requests confirmation before starting removal
- Shows detailed information about each removal step
- Doesn't remove system packages that may be needed by other programs

## Supported Systems

- **Linux** (Ubuntu/Debian with apt)
- **macOS** (with Homebrew)

## Installed Tools

### System packages:

- git, bison, ripgrep, fzf, unzip, wget, curl, gzip
- tmux, screen, zsh, gcc, python3, make, cmake
- luarocks, mycli, duf, ncdu, iftop, vnstat, qrencode
- autossh, jq, btop, htop, httpie, trash-cli, entr

### Version managers and languages:

- **Node.js** via nvm (v20)
- **Rust** and cargo
- **Go** via gvm (go1.22.0)
- **Bun**
- **Python** virtual environment

### Development tools:

- **Neovim** (via bob version manager)
- **Lazygit**
- **Git Delta** (git diff highlighter)
- **Bat** (cat with syntax highlighting)
- **Oh My Zsh** with custom theme

### Cargo packages:

- stylua, tree-sitter-cli, bob-nvim, eza

### Go tools:

- shfmt, lemonade, tmux-fastcopy

### Python packages:

- libtmux, mdformat

### Node.js packages:

- yarn@1.22.19, prettier

## Project Structure

```
├── main.sh              # Main installation script
├── main-uninstall.sh    # Uninstall script
├── env.example          # Configuration example
├── .env                 # Your configuration (created from env.example)
└── scripts/             # Installation and configuration modules
    ├── common.sh        # Common functions
    ├── package_manager.sh # Package manager operations
    ├── git.sh           # Git configuration
    ├── nvm.sh           # Node.js installation via nvm
    ├── rust.sh          # Rust and Cargo installation
    ├── gvm.sh           # Go installation via gvm
    ├── python.sh        # Python virtual environment
    ├── bun.sh           # Bun installation
    ├── docker.sh        # Docker installation
    ├── dotfiles.sh      # Dotfiles management
    ├── zsh.sh           # Zsh and Oh My Zsh configuration
    ├── nvim.sh          # Neovim installation and configuration
    ├── bat.sh           # bat configuration
    ├── lazygit.sh       # lazygit installation and configuration
    ├── mycli.sh         # mycli configuration
    ├── tmux.sh          # tmux configuration
    ├── screen.sh        # screen configuration
    ├── lemonade.sh      # lemonade configuration
    └── btop.sh          # btop configuration
```

## Requirements

- **Linux**: Ubuntu/Debian with sudo privileges
- **macOS**: Installed Homebrew
- Internet connection for downloading packages
- Permissions to change shell (for zsh)

## Environment Variables

In `.env` file you can configure:

- `SERVER_NAME` - server name for zsh theme
- `GIT_USER_NAME` - Git user name
- `GIT_USER_EMAIL` - Git email
- `OH_MY_ZSH_NAME` - name to display in zsh prompt
- `ARCH_OVERRIDE` - override system architecture
- `INSTALL_DOCKER` - install Docker (Linux only)
