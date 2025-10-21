#!/bin/bash
# System Prerequisites Check
# Validates that required tools are installed and reports optional tools

set +e  # Don't exit on errors

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track missing tools
MISSING_REQUIRED=()
MISSING_OPTIONAL=()
ALL_REQUIRED_FOUND=true

# Version comparison function
# Returns 0 if $1 >= $2, 1 otherwise
version_ge() {
    [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

# Extract version number from version string
extract_version() {
    echo "$1" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1
}

# Check Node.js
check_nodejs() {
    local min_version="20.0.0"
    
    if command -v node >/dev/null 2>&1; then
        local version=$(node --version 2>/dev/null | sed 's/v//')
        local clean_version=$(extract_version "$version")
        
        if [ -n "$clean_version" ] && version_ge "$clean_version" "$min_version"; then
            echo -e "  ${GREEN}✔${NC} Node.js v$version (>= $min_version)"
            return 0
        else
            echo -e "  ${RED}✘${NC} Node.js v$version (requires >= $min_version)"
            MISSING_REQUIRED+=("nodejs")
            ALL_REQUIRED_FOUND=false
            return 1
        fi
    else
        echo -e "  ${RED}✘${NC} Node.js - Not found (required, minimum v$min_version)"
        MISSING_REQUIRED+=("nodejs")
        ALL_REQUIRED_FOUND=false
        return 1
    fi
}

# Check npm
check_npm() {
    local min_version="9.0.0"
    
    if command -v npm >/dev/null 2>&1; then
        local version=$(npm --version 2>/dev/null)
        local clean_version=$(extract_version "$version")
        
        if [ -n "$clean_version" ] && version_ge "$clean_version" "$min_version"; then
            echo -e "  ${GREEN}✔${NC} npm v$version (>= $min_version)"
            return 0
        else
            echo -e "  ${RED}✘${NC} npm v$version (requires >= $min_version)"
            MISSING_REQUIRED+=("npm")
            ALL_REQUIRED_FOUND=false
            return 1
        fi
    else
        echo -e "  ${RED}✘${NC} npm - Not found (required, minimum v$min_version)"
        MISSING_REQUIRED+=("npm")
        ALL_REQUIRED_FOUND=false
        return 1
    fi
}

# Check Git
check_git() {
    if command -v git >/dev/null 2>&1; then
        local version=$(git --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        echo -e "  ${GREEN}✔${NC} Git v$version"
        return 0
    else
        echo -e "  ${RED}✘${NC} Git - Not found (required)"
        MISSING_REQUIRED+=("git")
        ALL_REQUIRED_FOUND=false
        return 1
    fi
}

# Check Docker
check_docker() {
    if command -v docker >/dev/null 2>&1; then
        local version=$(docker --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        echo -e "  ${GREEN}✔${NC} Docker v$version"
        return 0
    else
        echo -e "  ${YELLOW}⚠${NC} Docker - Not found (recommended for containerization)"
        MISSING_OPTIONAL+=("docker")
        return 1
    fi
}

# Check docker compose
check_docker_compose() {
    # Try 'docker compose' (newer) first, then 'docker-compose' (older)
    if docker compose version >/dev/null 2>&1; then
        local version=$(docker compose version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        echo -e "  ${GREEN}✔${NC} docker compose v$version"
        return 0
    elif command -v docker-compose >/dev/null 2>&1; then
        local version=$(docker-compose --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        echo -e "  ${GREEN}✔${NC} docker-compose v$version"
        return 0
    else
        echo -e "  ${YELLOW}⚠${NC} docker compose - Not found (recommended for multi-container setup)"
        MISSING_OPTIONAL+=("docker-compose")
        return 1
    fi
}

# Check Python 3
check_python3() {
    if command -v python3 >/dev/null 2>&1; then
        local version=$(python3 --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        echo -e "  ${GREEN}✔${NC} Python 3 v$version"
        return 0
    elif command -v python >/dev/null 2>&1; then
        local version=$(python --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        local major=$(echo "$version" | cut -d. -f1)
        if [ "$major" = "3" ]; then
            echo -e "  ${GREEN}✔${NC} Python v$version"
            return 0
        fi
    fi
    
    echo -e "  ${YELLOW}⚠${NC} Python 3 - Not found (recommended for pre-commit hooks)"
    MISSING_OPTIONAL+=("python3")
    return 1
}

# Print installation instructions
print_installation_instructions() {
    echo ""
    echo -e "${BLUE}Installation Instructions:${NC}"
    echo ""
    
    for tool in "${MISSING_REQUIRED[@]}"; do
        case "$tool" in
            nodejs)
                echo "Node.js v20 or higher:"
                echo "  - Download: https://nodejs.org/"
                echo "  - macOS: brew install node@20"
                echo "  - Ubuntu/Debian: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs"
                echo "  - Windows: Download from https://nodejs.org/ or use nvm-windows"
                echo ""
                ;;
            npm)
                echo "npm v9 or higher:"
                echo "  - Usually comes with Node.js"
                echo "  - Update: npm install -g npm@latest"
                echo ""
                ;;
            git)
                echo "Git:"
                echo "  - Download: https://git-scm.com/"
                echo "  - macOS: brew install git"
                echo "  - Ubuntu/Debian: sudo apt-get install git"
                echo "  - Windows: Download from https://git-scm.com/"
                echo ""
                ;;
        esac
    done
    
    if [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
        echo "Optional tools (install if needed):"
        echo ""
        
        for tool in "${MISSING_OPTIONAL[@]}"; do
            case "$tool" in
                docker)
                    echo "Docker:"
                    echo "  - Download: https://www.docker.com/get-started"
                    echo "  - macOS: brew install --cask docker"
                    echo "  - Ubuntu: https://docs.docker.com/engine/install/ubuntu/"
                    echo ""
                    ;;
                docker-compose)
                    echo "docker compose:"
                    echo "  - Included with Docker Desktop"
                    echo "  - Linux: https://docs.docker.com/compose/install/"
                    echo ""
                    ;;
                python3)
                    echo "Python 3:"
                    echo "  - Download: https://www.python.org/"
                    echo "  - macOS: brew install python3"
                    echo "  - Ubuntu/Debian: sudo apt-get install python3 python3-pip"
                    echo "  - Windows: Download from https://www.python.org/"
                    echo ""
                    ;;
            esac
        done
    fi
}

# Main execution
main() {
    echo ""
    echo "============================================"
    echo "Checking system prerequisites..."
    echo "============================================"
    echo ""
    
    # Check required tools
    echo "Required Tools:"
    check_nodejs
    check_npm
    check_git
    echo ""
    
    # Check optional tools
    echo "Optional Tools:"
    check_docker
    check_docker_compose
    check_python3
    echo ""
    
    # Print results
    if [ "$ALL_REQUIRED_FOUND" = true ]; then
        echo -e "${GREEN}✔ All required tools found!${NC}"
        
        if [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
            echo ""
            echo -e "${YELLOW}Note: Some optional tools are missing. You can install them later if needed.${NC}"
        fi
    else
        echo -e "${RED}✘ Missing required tools!${NC}"
        echo ""
        echo "The project may not work correctly until all required tools are installed."
        
        print_installation_instructions
    fi
    
    echo ""
    echo "============================================"
    echo ""
    
    # Always exit 0 to not block project generation
    exit 0
}

# Run main
main

