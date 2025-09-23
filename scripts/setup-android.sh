#!/bin/bash
# Android-specific setup script
set -euo pipefail

# Source version utilities
source "$(dirname "$0")/version-utils.sh"

setup_android_environment() {
    local release_tag="$1"
    
    echo "🔧 Setting up Android build environment..."
    
    # Export version variables
    export_version_vars "$release_tag"
    
    # Create keystore from secret
    echo "🔑 Setting up Android keystore..."
    if [[ -z "${ANDROID_KEYSTORE_BASE64:-}" ]]; then
        echo "❌ ERROR: ANDROID_KEYSTORE_BASE64 environment variable is not set"
        return 1
    fi
    
    echo "$ANDROID_KEYSTORE_BASE64" | base64 --decode > android/keystore.jks
    chmod 600 android/keystore.jks
    
    # Create key.properties
    echo "📄 Creating key.properties..."
    cat > android/key.properties << EOF
storePassword=$ANDROID_STORE_PASSWORD
keyPassword=$ANDROID_KEY_PASSWORD
keyAlias=$ANDROID_KEY_ALIAS
storeFile=../keystore.jks
EOF
    
    # Update local.properties
    echo "📄 Updating local.properties..."
    cat > android/local.properties << EOF
flutter.versionName=$VERSION_NAME
flutter.versionCode=$VERSION_CODE
flutter.sdk=$FLUTTER_ROOT
EOF
    
    echo "✅ Android build environment configured"
    echo "  - Version: $VERSION_NAME ($VERSION_CODE)"
    echo "  - Keystore: android/keystore.jks"
    echo "  - Properties: android/key.properties, android/local.properties"
}

# Run setup if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <release_tag>"
        exit 1
    fi
    
    setup_android_environment "$1"
fi
