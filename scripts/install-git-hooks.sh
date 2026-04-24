#!/usr/bin/env bash
#
# Point this repository at the tracked hook directory and make the hook scripts executable.
#
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ensure both the hook entrypoint and its helper script can actually run.
chmod +x "$repo_root/.githooks/pre-commit"
chmod +x "$repo_root/scripts/check-public-commit-safety.sh"

git -C "$repo_root" config core.hooksPath .githooks

echo "Installed repository hooks from .githooks/."
