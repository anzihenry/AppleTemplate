#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default project name
DEFAULT_NAME="AppleTemplate"
PROJECT_NAME="${1:-}"

# Print colored message
info() { echo -e "${BLUE}ℹ  $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠  $1${NC}"; }
error() { echo -e "${RED}✗ $1${NC}"; }

# Validate project name
validate_name() {
	local name="$1"
	if [[ -z "$name" ]]; then
		error "Project name cannot be empty"
		return 1
	fi
	if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
		error "Invalid name: must start with a letter and contain only letters, numbers, hyphens, or underscores"
		return 1
	fi
	return 0
}

# Get project name
if [ -z "$PROJECT_NAME" ]; then
	echo ""
	echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
	echo -e "${BLUE}║  AppleTemplate Project Generator     ║${NC}"
	echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
	echo ""
	read -p "Enter project name [$DEFAULT_NAME]: " PROJECT_NAME
	PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_NAME}"
fi

if ! validate_name "$PROJECT_NAME"; then
	exit 1
fi

success "Project name: $PROJECT_NAME"

# Check XcodeGen
info "Checking XcodeGen..."
if ! command -v xcodegen &>/dev/null; then
	warn "XcodeGen not found, installing via Homebrew..."
	if ! command -v brew &>/dev/null; then
		error "Homebrew not found. Please install it first: https://brew.sh"
		exit 1
	fi
	brew install xcodegen
fi
success "XcodeGen is ready"

# Generate project.yml
info "Generating project.yml..."

cat >project.yml <<EOF
name: $PROJECT_NAME

options:
  bundleIdPrefix: com.biucing
  deploymentTarget:
    iOS: "26.0"
    macOS: "26.0"
    watchOS: "26.0"
    tvOS: "26.0"
  xcodeVersion: "26.0"
  createIntermediateGroups: true

settings:
  base:
    SWIFT_VERSION: "6.2"
    GENERATE_INFOPLIST_FILE: YES

packages:
  AppCore:
    path: Packages/AppCore
  AppUI:
    path: Packages/AppUI
  AppData:
    path: Packages/AppData

targets:
  $PROJECT_NAME-iOS:
    type: application
    platform: iOS
    sources:
      - path: Platforms/iOS
      - path: Shared
        optional: true
    dependencies:
      - package: AppCore
      - package: AppUI
      - package: AppData
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.biucing.$PROJECT_NAME.iOS
        INFOPLIST_FILE: Platforms/iOS/Resources/Info.plist
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        MARKETING_VERSION: "1.0.0"
        CURRENT_PROJECT_VERSION: 1

  $PROJECT_NAME-macOS:
    type: application
    platform: macOS
    sources:
      - path: Platforms/macOS
      - path: Shared
        optional: true
    dependencies:
      - package: AppCore
      - package: AppUI
      - package: AppData
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.biucing.$PROJECT_NAME.macOS
        INFOPLIST_FILE: Platforms/macOS/Resources/Info.plist
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        MARKETING_VERSION: "1.0.0"
        CURRENT_PROJECT_VERSION: 1

  $PROJECT_NAME-watchOS:
    type: application
    platform: watchOS
    sources:
      - path: Platforms/watchOS
      - path: Shared
        optional: true
    dependencies:
      - package: AppCore
      - package: AppUI
      - package: AppData
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.biucing.$PROJECT_NAME.watchOS
        MARKETING_VERSION: "1.0.0"
        CURRENT_PROJECT_VERSION: 1

  $PROJECT_NAME-tvOS:
    type: application
    platform: tvOS
    sources:
      - path: Platforms/tvOS
      - path: Shared
        optional: true
    dependencies:
      - package: AppCore
      - package: AppUI
      - package: AppData
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.biucing.$PROJECT_NAME.tvOS
        MARKETING_VERSION: "1.0.0"
        CURRENT_PROJECT_VERSION: 1
EOF

success "project.yml generated"

# Run XcodeGen
info "Generating Xcode project..."
xcodegen generate

success "Project generated: ${PROJECT_NAME}.xcodeproj"
echo ""

# Ask to open Xcode
read -p "Open in Xcode? (y/n) " OPEN_XCODE
if [[ "$OPEN_XCODE" =~ ^[Yy]$ ]]; then
	open "${PROJECT_NAME}.xcodeproj"
	success "Opening Xcode..."
else
	info "You can open it later with: open ${PROJECT_NAME}.xcodeproj"
fi

echo ""
success "Done! Happy coding 🚀"
