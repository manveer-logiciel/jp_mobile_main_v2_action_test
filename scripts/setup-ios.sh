#!/bin/bash
# iOS-specific setup script
set -euo pipefail

# Source version utilities
source "$(dirname "$0")/version-utils.sh"

# Function to safely set plist value (add if doesn't exist, set if exists)
safe_plist_set() {
    local plist_file="$1"
    local key="$2"
    local value="$3"
    
    if /usr/libexec/PlistBuddy -c "Print :$key" "$plist_file" >/dev/null 2>&1; then
        /usr/libexec/PlistBuddy -c "Set :$key $value" "$plist_file"
    else
        /usr/libexec/PlistBuddy -c "Add :$key string $value" "$plist_file"
    fi
}

# Function to safely set pbxproj value
safe_pbxproj_set() {
    local target_id="$1"
    local key="$2"
    local value="$3"
    
    if /usr/libexec/PlistBuddy -c "Print :objects:$target_id:buildSettings:$key" ios/Runner.xcodeproj/project.pbxproj >/dev/null 2>&1; then
        /usr/libexec/PlistBuddy -c "Set :objects:$target_id:buildSettings:$key $value" ios/Runner.xcodeproj/project.pbxproj
    else
        /usr/libexec/PlistBuddy -c "Add :objects:$target_id:buildSettings:$key string $value" ios/Runner.xcodeproj/project.pbxproj
    fi
}

update_ios_version() {
    local release_tag="$1"
    
    echo "📝 Updating iOS version..."
    
    # Export version variables
    export_version_vars "$release_tag"
    
    # Update Info.plist for main app
    echo "📱 Updating main app Info.plist..."
    safe_plist_set "ios/Runner/Info.plist" "CFBundleShortVersionString" "$VERSION_NAME"
    safe_plist_set "ios/Runner/Info.plist" "CFBundleVersion" "$VERSION_CODE"
    
    # Update Info.plist for share extension
    echo "📱 Updating share extension Info.plist..."
    safe_plist_set "ios/Share Extension/Info.plist" "CFBundleShortVersionString" "$VERSION_NAME"
    safe_plist_set "ios/Share Extension/Info.plist" "CFBundleVersion" "$VERSION_CODE"
    
    echo "✅ iOS version updated successfully"
    echo "  - Version: $VERSION_NAME ($VERSION_CODE)"
}

configure_ios_signing() {
    echo "🔧 Configuring Xcode project for manual signing..."
    
    # Configure main app (Runner target) - Debug, Release, Profile
    echo "📱 Configuring main app signing..."
    safe_pbxproj_set "97C147061CF9000F007C117D" "CODE_SIGN_STYLE" "Manual"
    safe_pbxproj_set "97C147071CF9000F007C117D" "CODE_SIGN_STYLE" "Manual"
    safe_pbxproj_set "249021D4217E4FDB00AE95B9" "CODE_SIGN_STYLE" "Manual"
    
    safe_pbxproj_set "97C147061CF9000F007C117D" "CODE_SIGN_IDENTITY" "Apple Distribution"
    safe_pbxproj_set "97C147071CF9000F007C117D" "CODE_SIGN_IDENTITY" "Apple Distribution"
    safe_pbxproj_set "249021D4217E4FDB00AE95B9" "CODE_SIGN_IDENTITY" "Apple Distribution"
    
    # Configure Share Extension target - Debug, Release, Profile
    echo "📱 Configuring Share Extension signing..."
    safe_pbxproj_set "E2B11C5528B6384500902FF7" "CODE_SIGN_STYLE" "Manual"
    safe_pbxproj_set "E2B11C5628B6384500902FF7" "CODE_SIGN_STYLE" "Manual"
    safe_pbxproj_set "E2B11C5728B6384500902FF7" "CODE_SIGN_STYLE" "Manual"
    
    safe_pbxproj_set "E2B11C5528B6384500902FF7" "CODE_SIGN_IDENTITY" "Apple Distribution"
    safe_pbxproj_set "E2B11C5628B6384500902FF7" "CODE_SIGN_IDENTITY" "Apple Distribution"
    safe_pbxproj_set "E2B11C5728B6384500902FF7" "CODE_SIGN_IDENTITY" "Apple Distribution"
    
    echo "✅ Xcode project configured for manual signing"
}

setup_ios_environment() {
    local release_tag="$1"
    
    echo "🔧 Setting up iOS build environment..."
    
    # Update version first
    update_ios_version "$release_tag"
    
    # Configure signing
    configure_ios_signing
    
    echo "✅ iOS build environment configured"
}

# Run setup if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <release_tag>"
        exit 1
    fi
    
    setup_ios_environment "$1"
fi
