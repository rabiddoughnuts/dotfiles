# Project Compass

Purpose: Durable workspace direction, constraints, and near-term risks.
Belongs here: Stable goals, inferred direction, and important operating constraints.
Does not belong: Detailed task logs or temporary troubleshooting chatter.

## Snapshot
- Stated direction: Maintain a reusable dotfiles and system-bootstrap repository centered on Neovim, shell homefiles, and private-state tooling.
- Inferred direction: Keep public automation reproducible while separating sensitive or machine-specific state into adjacent private workflows.
- Current constraints: The repo already contains an established `.copilot/` workflow; imported `AGENTS.md` adds a parallel `.agent/` workflow for non-Copilot agents and should not overwrite Copilot state.
- Near-term risks: Cross-tool instruction drift between `AGENTS.md` and `.github/copilot-instructions.md`; stale `.agent/active-task.md` if it is not trimmed after tasks complete.
