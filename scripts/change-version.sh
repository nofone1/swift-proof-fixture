#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION_ARG="${1:-}"

if [[ -z "$VERSION_ARG" ]]; then
  echo "Usage: $0 <version>"
  echo "Examples: $0 v1, $0 1"
  echo "Available versions:" 
  ls "$ROOT_DIR/versions"/v*.swift 2>/dev/null | sed 's#.*/v##; s/\.swift$//' || true
  exit 1
fi

VERSION="${VERSION_ARG#v}"
SOURCE_FILE="$ROOT_DIR/versions/v$VERSION.swift"
TARGET_FILE="$ROOT_DIR/SwiftMinimal/ContentView.swift"

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Version not found: v$VERSION"
  echo "Expected file: $SOURCE_FILE"
  echo "Available versions:" 
  ls "$ROOT_DIR/versions"/v*.swift 2>/dev/null | sed 's#.*/v##; s/\.swift$//' || true
  exit 1
fi

cp "$SOURCE_FILE" "$TARGET_FILE"
echo "Switched ContentView.swift to v$VERSION"
