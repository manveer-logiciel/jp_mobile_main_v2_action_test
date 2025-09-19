#!/bin/bash

# Local Build Script - Mimics GitHub Actions
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}🔄 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Parse command line arguments
APP_VERSION=${1:-"3.37.2"}
BUILD_NUMBER=${2:-"303700200"}
BUILD_PLATFORM=${3:-"Android"}

print_step "Starting local build preparation..."
echo "📋 App Version: $APP_VERSION"
echo "🔢 Build Number: $BUILD_NUMBER"
echo "🏗️  Platform: $BUILD_PLATFORM"
echo ""

# Validate inputs
print_step "Validating inputs..."
if [[ ! $APP_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Invalid version format. Expected format: x.y.z (e.g., 3.37.2)"
    exit 1
fi

if [[ ! $BUILD_NUMBER =~ ^[0-9]+$ ]]; then
    print_error "Build number must be numeric"
    exit 1
fi

print_success "Input validation successful"

# Update version files
print_step "Updating version files..."

# Update pubspec.yaml
sed -i.bak "s/^version: .*/version: $APP_VERSION+$BUILD_NUMBER/" pubspec.yaml
print_success "Updated pubspec.yaml: $APP_VERSION+$BUILD_NUMBER"

# Update global.dart
sed -i.bak "s/String appVersion = '[^']*';/String appVersion = '$APP_VERSION';/" lib/common/libraries/global.dart
print_success "Updated lib/common/libraries/global.dart: $APP_VERSION"

# Update iOS marketing version
sed -i.bak "s/MARKETING_VERSION = [^;]*/MARKETING_VERSION = $APP_VERSION/" ios/Runner.xcodeproj/project.pbxproj
print_success "Updated iOS marketing version: $APP_VERSION"

# Clean up backup files
rm -f pubspec.yaml.bak lib/common/libraries/global.dart.bak ios/Runner.xcodeproj/project.pbxproj.bak

# Check if we should build Android
if [[ $BUILD_PLATFORM == "Android" || $BUILD_PLATFORM == "Both" ]]; then
    print_step "Building Android App Bundle (.aab)..."
    
    # Create local.properties for Android
    echo "flutter.versionName=$APP_VERSION" > android/local.properties
    echo "flutter.versionCode=$BUILD_NUMBER" >> android/local.properties
    
    # Check if Flutter is available
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter not found. Please install Flutter and add it to PATH."
        exit 1
    fi
    
    # Get Flutter dependencies
    print_step "Getting Flutter dependencies..."
    flutter pub get
    
    # Build App Bundle
    print_step "Building release App Bundle..."
    flutter build appbundle --release
    
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        BUNDLE_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
        print_success "Android App Bundle built successfully!"
        echo "📦 Bundle Size: $BUNDLE_SIZE"
        echo "📁 Location: build/app/outputs/bundle/release/app-release.aab"
    else
        print_error "Failed to build Android App Bundle"
        exit 1
    fi
fi

# Check if we should build iOS
if [[ $BUILD_PLATFORM == "iOS" || $BUILD_PLATFORM == "Both" ]]; then
    print_step "Building iOS app..."
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_warning "iOS builds require macOS. Skipping iOS build."
    else
        # Install CocoaPods dependencies
        print_step "Installing CocoaPods dependencies..."
        cd ios
        pod install
        cd ..
        
        # Build iOS (no code signing)
        print_step "Building iOS (no code signing)..."
        flutter build ios --release --no-codesign
        
        print_success "iOS build completed (no code signing)"
        print_warning "Note: Code signing and .ipa generation requires Apple Developer certificates"
    fi
fi

echo ""
print_success "🎉 Local build completed successfully!"
echo ""
echo "📋 Build Summary:"
echo "   Version: $APP_VERSION"
echo "   Build Number: $BUILD_NUMBER"
echo "   Platform: $BUILD_PLATFORM"
echo ""
echo "🚀 Ready for testing or deployment!"
