#!/bin/bash
# Colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
purple='\033[0;35m'
cyan='\033[0;36m'
blue='\033[0;34m'
rest='\033[0m'

# If running in Termux, update and upgrade
if [ -d "$HOME/.termux" ] && [ -z "$(command -v jq)" ]; then
    echo "Running update & upgrade ..."
    pkg update -y
    pkg upgrade -y
fi

install_packages() {
    local packages=(curl git zsh)
    local missing_packages=()
    local package_managers=(pkg apt yum dnf yay)
    local command=""

    # Get package manager
    for pm in "${package_managers[@]}"; do
      if command -v "$pm" &> /dev/null; then
          command="$pm"
          break
      fi
    done

    # Check for missing packages
    for pkg in "${packages[@]}"; do
        if ! command -v "$pkg" &> /dev/null; then
            missing_packages+=("$pkg")
        fi
    done

    if [ ${#missing_packages[@]} -eq 0 ]; then
        echo -e "${green}All required packages are already installed.${rest}"
        return
    fi

    # If any package is missing, install missing packages
    if [ ${#packages[@]} -gt 0 ]; then
        echo -e "${purple}============= Install Packages: ${missing_packages[@]} =============${rest}"
        echo -e "${green}COMMAND SYSTEM: $command ${rest}"
        case "$command" in
          pkg)
            pkg install "${missing_packages[@]}" -y
            ;;
          yum)
            sudo yum update -y
            sudo yum install "${missing_packages[@]}" -y
            ;;
          apt)
            sudo apt update -y
            sudo apt install "${missing_packages[@]}" -y
            ;;
          dnf)
            sudo dnf update -y
            sudo dnf install "${missing_packages[@]}" -y
            ;;
          yay)
            sudo yay -Syu
            sudo yay -S "${missing_packages[@]}"
            ;;
          *)
            echo -e "${yellow}Unsupported package manager. Please install required packages manually.${rest}"
            ;;
          esac
    fi
}

# Install the necessary packages
install_packages

# Clear the screen
clear