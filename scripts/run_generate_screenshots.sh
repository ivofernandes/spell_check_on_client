#!/usr/bin/env bash
set -euo pipefail

# Optional: set DEVICE_ID to force a specific device (recommended for iOS).
# Example:
# DEVICE_ID=E3592F85-F0DE-4C34-9C14-AC1CE128052C ./scripts/run_generate_screenshots.sh
DEVICE_ID="${DEVICE_ID:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${SCRIPT_DIR}/../example" >/dev/null
flutter pub get

DRIVE_ARGS=(--driver=test_driver/integration_test.dart)
if [[ -n "${DEVICE_ID}" ]]; then
  DRIVE_ARGS+=(--device-id="${DEVICE_ID}")
fi

flutter drive "${DRIVE_ARGS[@]}" --target=integration_test/screenshot_test_generated.dart

popd >/dev/null
