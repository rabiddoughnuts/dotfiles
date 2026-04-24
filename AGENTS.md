# Agent Instructions

Purpose: Stable operating rules for agent work in this workspace.
Belongs here: Durable workflow rules, edit boundaries, verification expectations, and pointers to `.agent/` support files.
Does not belong: Running task notes, postmortems, or large execution logs.

## Authority
- This file is the primary instruction file for agent work in this repository.
- `.github/copilot-instructions.md` remains in place for the VS Code Copilot workflow and should not be treated as the only source of truth for non-Copilot agents.
- `.agent/` contains mutable working state and task support files. Keep policy here in `AGENTS.md`, not in the scratch files.

## Operating Model
- Inspect first. Do not assume project structure, script behavior, or framework layout without reading the relevant files.
- Prefer minimal, high-confidence changes over broad rewrites.
- For multi-step work, keep the current task state in `.agent/active-task.md`.
- For substantial changes, create a task-specific plan file under `.agent/plans/` and track it in `.agent/plan-tracker.md`.
- Use `.agent/issue-log.md` to record recurring failure modes and how to avoid them.

## Scratch Discipline
- Do not maintain a long running diary.
- `active-task.md` is the current state document and should stay short.
- Replace stale status rather than appending endless historical notes.
- Move meaningful multi-step execution detail into a dedicated plan file instead of bloating `active-task.md`.
- Archive only if something will be useful later; otherwise delete stale task files during maintenance.

## Edit Boundaries
- Agent support files under `.agent/` may be updated freely as part of normal work.
- Do not modify `.github/copilot-instructions.md` or `.copilot/` files unless the user explicitly requests changes to the Copilot setup.
- Treat wrapper-owned directories and child repos deliberately. This workspace contains wrapper-level files plus `backend/` and `frontend/` child repos.
- Never revert unrelated user changes.

## Verification
- Read the files you are about to change before editing them.
- After code changes, run the smallest useful verification step available: targeted script, test, typecheck, lint, or build.
- If verification is skipped, blocked, or unsafe, record that clearly in the final response and in `active-task.md` when it matters.

## Environment Hazards
- Filesystem operations on this workspace can be slow or unstable for deep recursive deletes. Prefer incremental cleanup over broad destructive commands.
- Large npm or git operations may behave poorly on this mount. Prefer one-step-at-a-time execution when prior evidence suggests instability.
- Be explicit about shell assumptions. This machine may use different shells across contexts.
- Do not keep backup `.git*` directories inside active repositories.

## `.agent/` Files
- `.agent/index.md`: file registry and intended roles.
- `.agent/workspace-map.md`: concise repo structure.
- `.agent/project-compass.md`: durable direction, constraints, and near-term risks.
- `.agent/issue-log.md`: recurring mistakes and prevention.
- `.agent/plan-tracker.md`: active/completed plan index.
- `.agent/active-task.md`: current task only.
- `.agent/plans/`: task-specific plan files.
- `.agent/archive/`: optional retired notes worth keeping.

## Maintenance
- Refresh `workspace-map.md` when repo structure changes materially.
- Refresh `project-compass.md` when project direction or major constraints change.
- Add to `issue-log.md` only for genuine recurring or important failure modes.
- Keep `plan-tracker.md` aligned with plan-file lifecycle.
- Trim or reset `active-task.md` when the active task is done.
