#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ  $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠  $1${NC}"; }
error() { echo -e "${RED}✗ $1${NC}"; }

# Default project name for validation
PROJECT_NAME="${1:-ValidateDemo}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMP_DIR=""

cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        info "Cleaning up temporary directory..."
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

echo ""
echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  AppleTemplate Validator             ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""

# Step 1: Check prerequisites
info "Step 1: Checking prerequisites..."

if ! command -v xcodegen &>/dev/null; then
    warn "XcodeGen not found, installing via Homebrew..."
    if ! command -v brew &>/dev/null; then
        error "Homebrew not found. Please install it first: https://brew.sh"
        exit 1
    fi
    brew install xcodegen
fi
success "XcodeGen is available"

if ! command -v xcodebuild &>/dev/null; then
    error "xcodebuild not found. Please install Xcode command line tools."
    exit 1
fi
success "xcodebuild is available"

# Step 2: Create temporary directory
info "Step 2: Creating temporary validation workspace..."
TEMP_DIR=$(mktemp -d)
VALIDATE_PROJECT="$TEMP_DIR/$PROJECT_NAME"
mkdir -p "$VALIDATE_PROJECT"

# Copy template files to temp directory
info "Copying template to temporary directory..."
cp -R "$SCRIPT_DIR/Packages" "$VALIDATE_PROJECT/"
cp -R "$SCRIPT_DIR/Platforms" "$VALIDATE_PROJECT/"
cp -R "$SCRIPT_DIR/Shared" "$VALIDATE_PROJECT/"
cp "$SCRIPT_DIR/.swiftformat" "$VALIDATE_PROJECT/"
cp "$SCRIPT_DIR/.swiftlint.yml" "$VALIDATE_PROJECT/"
cp "$SCRIPT_DIR/.gitignore" "$VALIDATE_PROJECT/"
success "Template copied"

# Step 3: Generate project.yml with validation project name
info "Step 3: Generating project.yml..."
cd "$VALIDATE_PROJECT"

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

# Step 4: Generate Xcode project
info "Step 4: Generating Xcode project with xcodegen..."
xcodegen generate
success "Xcode project generated: $PROJECT_NAME.xcodeproj"

# Step 5: Resolve SPM dependencies
info "Step 5: Resolving Swift Package Manager dependencies..."
xcodebuild -resolvePackageDependencies \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$PROJECT_NAME-iOS" \
    -destination "generic/platform=iOS Simulator" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    -quiet
success "SPM dependencies resolved"

# Step 6: Build for iOS Simulator
info "Step 6: Building for iOS Simulator..."
xcodebuild build \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$PROJECT_NAME-iOS" \
    -destination "generic/platform=iOS Simulator" \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    ONLY_ACTIVE_ARCH=YES \
    -quiet
success "iOS build succeeded"

# Step 7: Build for macOS
info "Step 7: Building for macOS..."
xcodebuild build \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$PROJECT_NAME-macOS" \
    -destination "generic/platform=macOS" \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    ONLY_ACTIVE_ARCH=YES \
    -quiet
success "macOS build succeeded"

# Step 8: Build for watchOS Simulator
info "Step 8: Building for watchOS Simulator..."
xcodebuild build \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$PROJECT_NAME-watchOS" \
    -destination "generic/platform=watchOS Simulator" \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    ONLY_ACTIVE_ARCH=YES \
    -quiet
success "watchOS build succeeded"

# Step 9: Build for tvOS Simulator
info "Step 9: Building for tvOS Simulator..."
xcodebuild build \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$PROJECT_NAME-tvOS" \
    -destination "generic/platform=tvOS Simulator" \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    ONLY_ACTIVE_ARCH=YES \
    -quiet
success "tvOS build succeeded"

# Summary
echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Validation Complete!                ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
success "Project name: $PROJECT_NAME"
success "iOS build: PASSED"
success "macOS build: PASSED"
success "watchOS build: PASSED"
success "tvOS build: PASSED"
echo ""
info "Temporary workspace cleaned up automatically."
info "Template is ready for use!"
