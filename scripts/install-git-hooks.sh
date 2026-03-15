#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

chmod +x "$repo_root/.githooks/pre-commit"
chmod +x "$repo_root/scripts/check-public-commit-safety.sh"

git -C "$repo_root" config core.hooksPath .githooks

echo "Installed repository hooks from .githooks/."
