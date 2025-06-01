#!/bin/bash

# =============================================================================
# Linux Setup Script - Refactored and Optimized
# =============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors and formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${SCRIPT_DIR}/setup.log"
readonly TEMP_DIR="/tmp/linux-setup-$$"

# Package configurations
readonly BASIC_PACKAGES=(
    build-essential man lspci curl less tree
    vim tmux htop git iotop nvtop rsync tldr
    bat fd-find ripgrep fzf duf direnv sshpass
    asciinema neofetch ncal tig gh lsd
)

readonly DESKTOP_PACKAGES=(
    peek xclip guake
)

readonly FONTS=(
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)

# =============================================================================
# Utility Functions
# =============================================================================

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        INFO)  echo -e "${GREEN}[INFO]${NC} $message" | tee -a "$LOG_FILE" ;;
        WARN)  echo -e "${YELLOW}[WARN]${NC} $message" | tee -a "$LOG_FILE" ;;
        ERROR) echo -e "${RED}[ERROR]${NC} $message" | tee -a "$LOG_FILE" ;;
        DEBUG) echo -e "${BLUE}[DEBUG]${NC} $message" | tee -a "$LOG_FILE" ;;
    esac
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

show_progress() {
    local current=$1
    local total=$2
    local task="$3"
    local percent=$((current * 100 / total))
    local bar_length=50
    local filled_length=$((percent * bar_length / 100))

    printf "\r${BLUE}Progress:${NC} ["
    printf "%*s" $filled_length | tr ' ' '='
    printf "%*s" $((bar_length - filled_length)) | tr ' ' '-'
    printf "] %d%% - %s" $percent "$task"
}

cleanup() {
    log INFO "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR" 2>/dev/null || true
}

handle_error() {
    local exit_code=$?
    log ERROR "Script failed with exit code $exit_code on line $1"
    cleanup
    exit $exit_code
}

# Handle Ctrl+C gracefully
trap 'log WARN "Script terminated by user"; cleanup; exit 130' INT
trap 'handle_error $LINENO' ERR

# =============================================================================
# System Functions
# =============================================================================

check_system() {
    log INFO "Checking system requirements..."

    if ! command -v apt &> /dev/null; then
        log ERROR "This script requires apt package manager (Ubuntu/Debian)"
        exit 1
    fi

    if [[ $EUID -eq 0 ]]; then
        log WARN "Running as root. Some operations may behave differently."
    fi

    # Check internet connectivity
    if ! ping -c 1 google.com &> /dev/null; then
        log ERROR "No internet connection detected"
        exit 1
    fi

    log INFO "System check passed"
}

update_system() {
    log INFO "Updating system packages..."

    # Ensure sudo is available
    if ! command -v sudo &> /dev/null; then
        log INFO "Installing sudo..."
        apt update && apt install -y sudo
    fi

    sudo apt update && sudo apt upgrade -y
    log INFO "System updated successfully"
}

# =============================================================================
# Package Installation Functions
# =============================================================================

install_packages() {
    local packages=("$@")
    local failed_packages=()

    log INFO "Installing ${#packages[@]} packages..."

    # Try to install all packages at once first
    if sudo apt install -y "${packages[@]}" 2>/dev/null; then
        log INFO "All packages installed successfully"
        return 0
    fi

    # If batch install fails, try individual packages
    log WARN "Batch install failed, trying individual packages..."
    local current=0

    for package in "${packages[@]}"; do
        ((current++))
        show_progress $current ${#packages[@]} "Installing $package"

        if sudo apt install -y "$package" 2>/dev/null; then
            log DEBUG "Successfully installed: $package"
        else
            log WARN "Failed to install: $package"
            failed_packages+=("$package")
        fi
    done

    echo  # New line after progress bar

    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log WARN "Failed to install: ${failed_packages[*]}"
        return 1
    fi

    return 0
}

install_basic_packages() {
    log INFO "Installing basic packages..."
    install_packages "${BASIC_PACKAGES[@]}"
}

install_desktop_packages() {
    log INFO "Installing desktop packages..."
    install_packages "${DESKTOP_PACKAGES[@]}"

    # Configure guake autostart
    if command -v guake &> /dev/null; then
        sudo cp -f /usr/share/applications/guake.desktop /etc/xdg/autostart/ 2>/dev/null || true
        log INFO "Configured guake autostart"
    fi
}

# =============================================================================
# Specialized Installation Functions
# =============================================================================

install_git() {
    log INFO "Installing latest Git..."

    if sudo add-apt-repository -y ppa:git-core/ppa 2>/dev/null; then
        sudo apt update
        sudo apt install -y git-all git-extras
        log INFO "Git installed from PPA"
    else
        log WARN "Failed to add Git PPA, using default version"
        sudo apt install -y git git-extras
    fi
}

install_neovim() {
    log INFO "Installing Neovim..."

    if sudo add-apt-repository -y ppa:neovim-ppa/stable 2>/dev/null; then
        sudo apt update
        sudo apt install -y neovim
        log INFO "Neovim installed from PPA"
    else
        log WARN "Failed to add Neovim PPA, trying manual installation..."
        install_neovim_manual
    fi
}

install_neovim_manual() {
    log INFO "Installing Neovim manually..."
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    if curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz; then
        tar -xzf nvim-linux64.tar.gz
        sudo cp -r nvim-linux64/* /usr/local/
        log INFO "Neovim installed manually to /usr/local"
    else
        log ERROR "Failed to download Neovim"
        return 1
    fi
}

install_fonts() {
    log INFO "Installing MesloLGS NF fonts..."

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    local current=0
    for font_url in "${FONTS[@]}"; do
        ((current++))
        local font_name=$(basename "$font_url")
        show_progress $current ${#FONTS[@]} "Downloading $font_name"

        if curl -fsSL "$font_url" -o "$font_dir/$font_name"; then
            log DEBUG "Downloaded: $font_name"
        else
            log WARN "Failed to download: $font_name"
        fi
    done

    echo  # New line after progress bar

    # Update font cache
    if command -v fc-cache &> /dev/null; then
        fc-cache -f -v > /dev/null 2>&1
        log INFO "Font cache updated"

        if fc-list | grep -q "MesloLGS"; then
            log INFO "MesloLGS fonts installed successfully"
        else
            log WARN "MesloLGS fonts may not be properly installed"
        fi
    fi
}

install_zsh() {
    log INFO "Installing and configuring Zsh..."

    sudo apt install -y zsh
    install_fonts

    # Set zsh as default shell
    local zsh_path=$(which zsh)
    if [[ "$SHELL" != "$zsh_path" ]]; then
        log INFO "Setting Zsh as default shell..."
        sudo chsh -s "$zsh_path" "$USER"
        log INFO "Default shell changed to Zsh (will take effect on next login)"
    fi
}

install_fasd() {
    log INFO "Installing FASD..."

    if sudo add-apt-repository -y ppa:aacebedo/fasd 2>/dev/null; then
        sudo apt update
        sudo apt install -y fasd
        log INFO "FASD installed from PPA"
    else
        log WARN "Failed to add FASD PPA, trying manual installation..."
        install_fasd_manual
    fi
}

install_fasd_manual() {
    log INFO "Installing FASD manually..."
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    if wget -q https://github.com/clvv/fasd/tarball/1.0.1 -O fasd.tar.gz; then
        tar -xzf fasd.tar.gz
        cd clvv-fasd-* && PREFIX="$HOME" make install
        log INFO "FASD installed manually to $HOME"
    else
        log ERROR "Failed to download FASD"
        return 1
    fi
}

install_anaconda() {
    log INFO "Installing Anaconda..."

    local anaconda_version="2024.02-1"  # Updated version
    local anaconda_file="Anaconda3-${anaconda_version}-Linux-x86_64.sh"
    local anaconda_url="https://repo.anaconda.com/archive/${anaconda_file}"

    if [[ ! -f "$anaconda_file" ]]; then
        log INFO "Downloading Anaconda..."
        if ! wget -q "$anaconda_url"; then
            log ERROR "Failed to download Anaconda"
            return 1
        fi
    fi

    log INFO "Installing Anaconda (this may take a while)..."
    bash "$anaconda_file" -b -p "$HOME/anaconda3"

    # Add to PATH if not already there
    if ! grep -q "anaconda3/bin" "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> "$HOME/.bashrc"
    fi

    log INFO "Anaconda installed successfully"
}

install_rust_tools() {
    log INFO "Installing Rust and related tools..."

    if ! command -v cargo &> /dev/null; then
        log INFO "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    log INFO "Installing sd (sed alternative)..."
    cargo install sd
}

install_node() {
    log INFO "Installing Node.js..."

    # Install Node.js via NodeSource repository
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings

    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
        sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

    local node_major=20
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$node_major.x nodistro main" | \
        sudo tee /etc/apt/sources.list.d/nodesource.list

    sudo apt-get update
    sudo apt-get install -y nodejs

    # Install global packages
    local npm_packages=(http-server create-react-app)
    log INFO "Installing global npm packages..."
    sudo npm install -g "${npm_packages[@]}"
}

install_node_manual() {
    log INFO "Installing Node.js via NVM (manual)..."

    # Install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Source NVM and install Node
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install 20
    nvm use 20

    log INFO "Node.js $(node -v) installed via NVM"
}

# =============================================================================
# Installation Profiles
# =============================================================================

install_desktop() {
    log INFO "Starting desktop installation profile..."

    local tasks=(
        "check_system"
        "update_system"
        "install_basic_packages"
        "install_desktop_packages"
        "install_zsh"
        "install_git"
        "install_neovim"
        "install_fasd"
        "install_anaconda"
        "install_rust_tools"
        "install_node"
    )

    local current=0
    local total=${#tasks[@]}

    for task in "${tasks[@]}"; do
        ((current++))
        log INFO "[$current/$total] Executing: $task"

        if $task; then
            log INFO "✓ Completed: $task"
        else
            log ERROR "✗ Failed: $task"
            return 1
        fi
    done

    log INFO "Desktop installation completed successfully!"
}

install_server() {
    log INFO "Starting server installation profile..."

    local tasks=(
        "check_system"
        "update_system"
        "install_basic_packages"
        "install_zsh"
        "install_git"
        "install_neovim"
        "install_fasd"
        "install_anaconda"
        "install_node"
    )

    local current=0
    local total=${#tasks[@]}

    for task in "${tasks[@]}"; do
        ((current++))
        log INFO "[$current/$total] Executing: $task"

        if $task; then
            log INFO "✓ Completed: $task"
        else
            log ERROR "✗ Failed: $task"
            return 1
        fi
    done

    log INFO "Server installation completed successfully!"
}

# =============================================================================
# Main Script Logic
# =============================================================================

show_help() {
    cat << EOF
${BOLD}Linux Setup Script - Refactored${NC}

${BOLD}USAGE:${NC}
    bash linux-setup.sh [OPTION]

${BOLD}OPTIONS:${NC}
    desktop, de    Install packages for desktop environment
    server, s      Install packages for server environment
    dl             Install deep learning nvidia environment
    help, h        Show this help message

${BOLD}EXAMPLES:${NC}
    bash linux-setup.sh desktop
    bash linux-setup.sh server
    bash linux-setup.sh dl

${BOLD}LOGS:${NC}
    Installation logs are saved to: $LOG_FILE

EOF
}

main() {
    # Initialize
    mkdir -p "$TEMP_DIR"
    mkdir -p "$(dirname "$LOG_FILE")"

    log INFO "=== Linux Setup Script Started ==="
    log INFO "Script directory: $SCRIPT_DIR"
    log INFO "Temporary directory: $TEMP_DIR"
    log INFO "Log file: $LOG_FILE"

    case "${1:-help}" in
        desktop|de)
            echo -e "${RED}│ ${YELLOW}Linux Setup - Desktop Profile${RED} │${NC}\n"
            install_desktop
            echo -e "\n${RED}│ ${GREEN}Desktop installation completed!${RED} │${NC}"
            ;;
        server|s*)
            echo -e "${RED}│ ${YELLOW}Linux Setup - Server Profile${RED} │${NC}\n"
            install_server
            echo -e "\n${RED}│ ${GREEN}Server installation completed!${RED} │${NC}"
            ;;
        dl)
            log INFO "Delegating to deep learning setup script..."
            if [[ -f "${SCRIPT_DIR}/dl-setup.sh" ]]; then
                bash "${SCRIPT_DIR}/dl-setup.sh"
            else
                log ERROR "dl-setup.sh not found in $SCRIPT_DIR"
                exit 1
            fi
            ;;
        help|h|*)
            show_help
            ;;
    esac

    cleanup
    log INFO "=== Linux Setup Script Completed ==="
}

# Run main function with all arguments
main "$@"
