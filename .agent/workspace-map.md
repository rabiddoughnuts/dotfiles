# Workspace Map

Purpose: Concise directory overview and working boundaries.
Belongs here: High-level folder roles and important repo structure notes.
Does not belong: Execution logs or environment facts.

## Top-Level
- `nvim/`: Neovim configuration and bootstrap scripts.
- `homefiles/`: Shell and user-home managed files mirrored by install paths.
- `capture/`: Private-state capture scripts and supporting files.
- `restore/`: Private-state restore scripts and helpers.
- `hooks/`: Hook templates used by installer scripts.
- `scripts/`: Operational helpers, sync, maintenance, and install utilities.
- `state-templates/`: Templates and notes for private-state bootstrap and setup.
- `systemd/`: Service and timer templates used by install helpers.
- `sys-installs/`: System software installer scripts and assignment-oriented docs.
- `.github/`: Repository metadata and Copilot-specific instructions.
- `.copilot/`: Existing Copilot workflow files kept separate from `.agent/`.
- `.agent/`: Agent-local support files for this repository.
- `.githooks/`: Repository hook support files.

## Boundaries
- Treat this repository as the root workspace; there are no child app repos under the current layout.
- Keep durable policy in `AGENTS.md` and current-agent state in `.agent/`.
- Avoid mixing `.agent/` and `.copilot/` responsibilities.
