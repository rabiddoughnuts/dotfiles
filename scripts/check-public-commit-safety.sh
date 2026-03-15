#!/usr/bin/env bash
set -euo pipefail

# Blocks commits that appear to include private state or secrets in the public repo.

mapfile -t staged_files < <(git diff --cached --name-only)

if [[ ${#staged_files[@]} -eq 0 ]]; then
  exit 0
fi

blocked_patterns=(
  '(^|/)private-state(/|$)'
  '(^|/)encrypted(/|$)'
  '(^|/)ssh-key-backups(/|$)'
  '(^|/)secrets-backups(/|$)'
  '(^|/)id_(rsa|ed25519)(\.pub)?$'
  '\.pem$'
  '\.p12$'
  '\.kdbx$'
)

violations=()
for f in "${staged_files[@]}"; do
  for p in "${blocked_patterns[@]}"; do
    if [[ "$f" =~ $p ]]; then
      violations+=("$f")
      break
    fi
  done
done

if [[ ${#violations[@]} -gt 0 ]]; then
  echo "ERROR: Potentially sensitive files detected in staged changes:" >&2
  for v in "${violations[@]}"; do
    echo "  - $v" >&2
  done
  echo >&2
  echo "Commit blocked. Move these files to your private-state repo." >&2
  exit 1
fi

exit 0
