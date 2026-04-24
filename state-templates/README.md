# State Templates

This directory stores the reference documents used to bootstrap or explain a sibling `private-state` repository. Unlike the operational scripts, these files are templates and layout guides rather than runnable code.

See the repository overview in [../README.md](../README.md).

## What It Does

The files here describe:

- what a private-state repository is for,
- what directory structure the public scripts expect,
- what bootstrap assumptions apply on a new machine.

## Files

- `private-repo-README.template.md`: Starter README text for a private-state repository.
- `private-state-layout.md`: Reference layout for the directories and metadata files expected by the scripts in this repo.

## How It Works

1. Use `private-repo-README.template.md` when creating or documenting a new private-state repo.
2. Use `private-state-layout.md` to confirm the directory structure expected by capture, restore, and integrity-check scripts.
3. Adjust any machine-specific paths or distro-specific bootstrap commands before treating the templates as canonical.

## Environment Assumptions

- The template README currently assumes an Arch-family bootstrap path (`pacman`, `paru`).
- The template README includes a machine-specific canonical path that must be edited for another machine or storage layout.
- The layout file assumes the public repo’s private-state tooling conventions, including `meta/`, `hosts/<hostname>/`, and `encrypted/` directories.

## Constraints And Caveats

- These templates are reference material, not generated artifacts.
- Some content is intentionally opinionated toward this machine and workflow, so it should be reviewed before reuse on a different host.
