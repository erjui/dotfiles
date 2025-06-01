#!/bin/bash

# =============================================================================
# macOS Setup Script - Refactored and Optimized
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
readonly TEMP_DIR="/tmp/mac-setup-$$"

# Package configurations
readonly BASIC_PACKAGES=(
    curl less tree htop vim neovim tmux
    tig gh bat ripgrep fzf duf lsd
    direnv asciinema neofetch ncal rsync tldr
    git git-lfs wget node nano fasd watch
)

readonly CASK_PACKAGES=(
    iterm2 visual-studio-code
)

readonly OPTIONAL_PACKAGES=(
    fd exa  # Alternative tools
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
    log INFO "Checking macOS system requirements..."

    # Check if running on macOS
    if [[ "$(uname)" != "Darwin" ]]; then
        log ERROR "This script is designed for macOS only"
        exit 1
    fi

    # Check macOS version
    local macos_version=$(sw_vers -productVersion)
    log INFO "macOS version: $macos_version"

    # Check architecture
    local arch=$(uname -m)
    log INFO "Architecture: $arch"

    # Check internet connectivity
    if ! ping -c 1 google.com &> /dev/null; then
        log ERROR "No internet connection detected"
        exit 1
    fi

    # Check Xcode Command Line Tools
    if ! xcode-select -p &> /dev/null; then
        log WARN "Xcode Command Line Tools not found. Installing..."
        xcode-select --install
        log INFO "Please complete Xcode Command Line Tools installation and re-run this script"
        exit 1
    fi

    log INFO "System check passed"
}

detect_architecture() {
    local arch=$(uname -m)
    case "$arch" in
        arm64)
            echo "arm64"
            ;;
        x86_64)
            echo "x86_64"
            ;;
        *)
            log ERROR "Unsupported architecture: $arch"
            exit 1
            ;;
    esac
}

# =============================================================================
# Homebrew Functions
# =============================================================================

install_homebrew() {
    log INFO "Installing Homebrew..."

    if command -v brew &> /dev/null; then
        log INFO "Homebrew already installed"
        return 0
    fi

    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH based on architecture
    local arch=$(detect_architecture)
    case "$arch" in
        arm64)
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
            ;;
        x86_64)
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
            ;;
    esac

    # Verify installation
    if command -v brew &> /dev/null; then
        log INFO "Homebrew installed successfully"
        brew --version | head -1 | log INFO
    else
        log ERROR "Homebrew installation failed"
        return 1
    fi
}

update_homebrew() {
    log INFO "Updating Homebrew..."
    brew update
    brew upgrade
    log INFO "Homebrew updated successfully"
}

# =============================================================================
# Package Installation Functions
# =============================================================================

install_brew_packages() {
    local packages=("$@")
    local failed_packages=()

    log INFO "Installing ${#packages[@]} Homebrew packages..."

    # Try to install all packages at once first
    if brew install "${packages[@]}" 2>/dev/null; then
        log INFO "All packages installed successfully"
        return 0
    fi

    # If batch install fails, try individual packages
    log WARN "Batch install failed, trying individual packages..."
    local current=0

    for package in "${packages[@]}"; do
        ((current++))
        show_progress $current ${#packages[@]} "Installing $package"

        if brew list "$package" &> /dev/null; then
            log DEBUG "Already installed: $package"
        elif brew install "$package" 2>/dev/null; then
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

install_cask_packages() {
    local packages=("$@")
    local failed_packages=()

    log INFO "Installing ${#packages[@]} Homebrew cask packages..."

    local current=0
    for package in "${packages[@]}"; do
        ((current++))
        show_progress $current ${#packages[@]} "Installing $package"

        if brew list --cask "$package" &> /dev/null; then
            log DEBUG "Already installed: $package"
        elif brew install --cask "$package" 2>/dev/null; then
            log DEBUG "Successfully installed: $package"
        else
            log WARN "Failed to install: $package"
            failed_packages+=("$package")
        fi
    done

    echo  # New line after progress bar

    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log WARN "Failed to install cask packages: ${failed_packages[*]}"
        return 1
    fi

    return 0
}

install_basic_packages() {
    log INFO "Installing basic packages..."
    install_brew_packages "${BASIC_PACKAGES[@]}"
}

install_desktop_packages() {
    log INFO "Installing desktop applications..."
    install_cask_packages "${CASK_PACKAGES[@]}"
}

install_optional_packages() {
    log INFO "Installing optional packages..."
    install_brew_packages "${OPTIONAL_PACKAGES[@]}"
}

# =============================================================================
# Specialized Installation Functions
# =============================================================================

install_anaconda() {
    log INFO "Installing Anaconda..."

    local arch=$(detect_architecture)
    local anaconda_version="2024.02-1"  # Updated version
    local anaconda_file=""
    local anaconda_url=""

    case "$arch" in
        arm64)
            anaconda_file="Anaconda3-${anaconda_version}-MacOSX-arm64.sh"
            ;;
        x86_64)
            anaconda_file="Anaconda3-${anaconda_version}-MacOSX-x86_64.sh"
            ;;
    esac

    anaconda_url="https://repo.anaconda.com/archive/${anaconda_file}"

    # Check if Anaconda is already installed
    if [[ -d "$HOME/anaconda3" ]] || command -v conda &> /dev/null; then
        log INFO "Anaconda already installed"
        return 0
    fi

    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    if [[ ! -f "$anaconda_file" ]]; then
        log INFO "Downloading Anaconda for $arch..."
        if ! wget -q "$anaconda_url"; then
            log ERROR "Failed to download Anaconda"
            return 1
        fi
    fi

    log INFO "Installing Anaconda (this may take a while)..."
    bash "$anaconda_file" -b -p "$HOME/anaconda3"

    # Add to PATH if not already there
    local shell_rc=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_rc="$HOME/.zshrc"
    else
        shell_rc="$HOME/.bash_profile"
    fi

    if ! grep -q "anaconda3/bin" "$shell_rc" 2>/dev/null; then
        echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> "$shell_rc"
        log INFO "Added Anaconda to PATH in $shell_rc"
    fi

    log INFO "Anaconda installed successfully"
}

configure_git() {
    log INFO "Configuring Git..."

    # Set up Git LFS
    if command -v git-lfs &> /dev/null; then
        git lfs install
        log INFO "Git LFS configured"
    fi

    # Basic Git configuration prompts
    if [[ -z "$(git config --global user.name 2>/dev/null || true)" ]]; then
        log INFO "Git user.name not set. Please configure manually with: git config --global user.name 'Your Name'"
    fi

    if [[ -z "$(git config --global user.email 2>/dev/null || true)" ]]; then
        log INFO "Git user.email not set. Please configure manually with: git config --global user.email 'your.email@example.com'"
    fi
}

configure_shell() {
    log INFO "Configuring shell environment..."

    # Set up shell configuration based on current shell
    local shell_rc=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_rc="$HOME/.zshrc"
        log INFO "Detected Zsh shell"
    else
        shell_rc="$HOME/.bash_profile"
        log INFO "Detected Bash shell"
    fi

    # Create shell config file if it doesn't exist
    touch "$shell_rc"

    # Add useful aliases if not already present
    local aliases=(
        "alias ll='ls -la'"
        "alias la='ls -A'"
        "alias l='ls -CF'"
        "alias ..='cd ..'"
        "alias ...='cd ../..'"
    )

    for alias_cmd in "${aliases[@]}"; do
        if ! grep -q "$alias_cmd" "$shell_rc" 2>/dev/null; then
            echo "$alias_cmd" >> "$shell_rc"
        fi
    done

    log INFO "Shell configuration updated in $shell_rc"
}

setup_development_environment() {
    log INFO "Setting up development environment..."

    # Configure Node.js
    if command -v node &> /dev/null; then
        local node_version=$(node --version)
        log INFO "Node.js $node_version installed"

        # Install useful global packages
        local npm_packages=(
            "http-server"
            "create-react-app"
            "typescript"
            "@vue/cli"
        )

        log INFO "Installing global npm packages..."
        for package in "${npm_packages[@]}"; do
            if ! npm list -g "$package" &> /dev/null; then
                npm install -g "$package" 2>/dev/null || log WARN "Failed to install $package"
            fi
        done
    fi

    # Set up Python symlinks if needed
    if command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
        log INFO "Creating python symlink to python3"
        # Note: On macOS, we typically don't create system-wide symlinks
        # Users should use python3 explicitly or set up their own aliases
    fi
}

# =============================================================================
# macOS-specific Configurations
# =============================================================================

configure_macos_settings() {
    log INFO "Configuring macOS settings..."

    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show file extensions in Finder
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Disable the "Are you sure you want to open this application?" dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Enable tap to click for trackpad
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    # Set a faster key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Restart Finder to apply changes
    killall Finder 2>/dev/null || true

    log INFO "macOS settings configured (some changes require logout/restart)"
}

# =============================================================================
# Installation Profiles
# =============================================================================

install_desktop() {
    log INFO "Starting macOS desktop installation profile..."

    local tasks=(
        "check_system"
        "install_homebrew"
        "update_homebrew"
        "install_basic_packages"
        "install_desktop_packages"
        "install_optional_packages"
        "install_anaconda"
        "configure_git"
        "configure_shell"
        "setup_development_environment"
        "configure_macos_settings"
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

install_minimal() {
    log INFO "Starting minimal macOS installation profile..."

    local tasks=(
        "check_system"
        "install_homebrew"
        "update_homebrew"
        "install_basic_packages"
        "configure_git"
        "configure_shell"
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

    log INFO "Minimal installation completed successfully!"
}

# =============================================================================
# Main Script Logic
# =============================================================================

show_help() {
    cat << EOF
${BOLD}macOS Setup Script - Refactored${NC}

${BOLD}USAGE:${NC}
    bash mac-setup.sh [OPTION]

${BOLD}OPTIONS:${NC}
    desktop, de    Install full desktop environment with applications
    minimal, min   Install minimal command-line tools only
    help, h        Show this help message

${BOLD}EXAMPLES:${NC}
    bash mac-setup.sh desktop
    bash mac-setup.sh minimal

${BOLD}FEATURES:${NC}
    • Automatic architecture detection (Intel/Apple Silicon)
    • Homebrew package management
    • Development environment setup
    • macOS system configuration
    • Comprehensive error handling and logging

${BOLD}LOGS:${NC}
    Installation logs are saved to: $LOG_FILE

${BOLD}REQUIREMENTS:${NC}
    • macOS 10.15+ (Catalina or later)
    • Xcode Command Line Tools
    • Internet connection

EOF
}

show_system_info() {
    log INFO "=== System Information ==="
    log INFO "macOS Version: $(sw_vers -productVersion)"
    log INFO "Architecture: $(uname -m)"
    log INFO "Hostname: $(hostname)"
    log INFO "User: $(whoami)"
    log INFO "Shell: $SHELL"
    log INFO "=========================="
}

main() {
    # Initialize
    mkdir -p "$TEMP_DIR"
    mkdir -p "$(dirname "$LOG_FILE")"

    log INFO "=== macOS Setup Script Started ==="
    log INFO "Script directory: $SCRIPT_DIR"
    log INFO "Temporary directory: $TEMP_DIR"
    log INFO "Log file: $LOG_FILE"

    show_system_info

    case "${1:-help}" in
        desktop|de)
            echo -e "${RED}│ ${YELLOW}macOS Setup - Desktop Profile${RED} │${NC}\n"
            install_desktop
            echo -e "\n${RED}│ ${GREEN}Desktop installation completed!${RED} │${NC}"
            echo -e "${YELLOW}Note: Some changes require a logout/restart to take effect.${NC}"
            ;;
        minimal|min)
            echo -e "${RED}│ ${YELLOW}macOS Setup - Minimal Profile${RED} │${NC}\n"
            install_minimal
            echo -e "\n${RED}│ ${GREEN}Minimal installation completed!${RED} │${NC}"
            ;;
        help|h|*)
            show_help
            ;;
    esac

    cleanup
    log INFO "=== macOS Setup Script Completed ==="
}

# Run main function with all arguments
main "$@"
