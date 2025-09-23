#!/bin/bash
# Version utility functions for CI/CD workflow
set -euo pipefail

# Calculate version name and code from release tag
calculate_version() {
    local release_tag="$1"
    
    # Version name is the release tag directly (e.g., 3.37.2)
    echo "VERSION_NAME=$release_tag"
    
    # Convert version to build number (e.g., 3.37.2 -> 303700200)
    IFS='.' read -ra VERSION_PARTS <<< "$release_tag"
    local version_code="$((${VERSION_PARTS[0]} * 10000000 + ${VERSION_PARTS[1]} * 100000 + ${VERSION_PARTS[2]} * 1000))"
    echo "VERSION_CODE=$version_code"
}

# Validate release tag format
validate_release_tag() {
    local release_tag="$1"
    
    # Validate release tag format (semantic version without 'v' prefix)
    if [[ ! $release_tag =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "❌ ERROR: Invalid release tag format. Expected format: x.y.z (e.g., 3.37.2)"
        return 1
    fi
    
    echo "✅ Release tag format is valid: $release_tag"
    return 0
}

# Extract and export version variables
export_version_vars() {
    local release_tag="$1"
    
    validate_release_tag "$release_tag" || return 1
    
    # Calculate and export version variables
    eval "$(calculate_version "$release_tag")"
    
    echo "📋 Version variables:"
    echo "  - VERSION_NAME: $VERSION_NAME"
    echo "  - VERSION_CODE: $VERSION_CODE"
    
    # Export to environment
    echo "VERSION_NAME=$VERSION_NAME" >> $GITHUB_ENV
    echo "VERSION_CODE=$VERSION_CODE" >> $GITHUB_ENV
    
    # Also export to output if called from a step
    if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
        echo "version_name=$VERSION_NAME" >> $GITHUB_OUTPUT
        echo "version_code=$VERSION_CODE" >> $GITHUB_OUTPUT
    fi
}
