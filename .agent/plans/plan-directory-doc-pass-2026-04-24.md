# Directory Documentation Pass Plan

Purpose: Track the directory-by-directory documentation and inline-comment sweep requested for this repository.
Belongs here: Current state, desired state, phases, and verification notes for this task.
Does not belong: Permanent project policy or unrelated task history.

## Current State

- Several directories contain working scripts/config files but only light or partial explanation.
- README coverage is uneven and often shorter than the actual behavior of the code.
- Larger directories such as `scripts/` and `nvim/` need deliberate sequential review to avoid shallow comments.

## Desired State

- Each reviewed directory has:
  - code files read individually before editing,
  - a short file header describing general use and role,
  - concise block comments where behavior or constraints are non-obvious,
  - a README that explains what is in the directory, how it works, and important environment assumptions.

## Phases

1. Small script directories:
   - `capture/`
   - `restore/`
   - `sys-installs/`
2. Medium shell-config directory:
   - `homefiles/`
3. Larger implementation directories:
   - `scripts/`
   - `nvim/`
4. Remaining support directories as needed:
   - `hooks/`
   - `systemd/`
   - `state-templates/`

## Progress

- Done: `capture/`, `restore/`, `sys-installs/`, `homefiles/`, `scripts/`, `hooks/`, `systemd/`, `state-templates/`
- Done: `nvim/`
- In progress: none
- Pending: none

## Verification Notes

- For bash scripts: run `bash -n` and a dry-run/help path when safe.
- For Fish files: run `fish -n`.
- For non-executable template/config directories: verify the README against the actual file layout.
