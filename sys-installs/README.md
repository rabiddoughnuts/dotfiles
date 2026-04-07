# sys-installs

This folder contains scripts for installing system software in a controlled way.

## Files

- `install-aws-cli.sh`: Installs AWS CLI on Ubuntu using apt prerequisites and the official AWS installer bundle.
- `Task3-implementation-plan.md`: Step-by-step implementation and validation plan for Task 3.

## What install-aws-cli.sh does

The script enforces the following safeguards and behavior:

1. Checks effective user ID and exits unless run as root (or via sudo).
2. Verifies `apt` exists before continuing.
3. Shows what will be installed and asks for `y` or `n` confirmation.
4. Checks whether `aws` command name already exists and exits on conflict.
5. Installs dependencies non-interactively and quietly with apt.
6. Downloads and installs AWS CLI, then prints a test command.

## Usage

From the repository root:

```bash
chmod +x sys-installs/install-aws-cli.sh
sudo ./sys-installs/install-aws-cli.sh
```

## Verify installation

Run:

```bash
aws --version
```

If installation succeeded, this command prints the AWS CLI version.

## Sources and citations

- [AWS CLI official installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html): Used for the Linux zip installer workflow and verification command.
- [Ubuntu apt manual page](https://manpages.ubuntu.com/manpages/jammy/man8/apt.8.html): Used for apt command behavior and non-interactive package installation flags.

## Generative AI usage disclosure

- Tool used: GitHub Copilot
- Model used: GPT-5.3-Codex
- How it was used: Assisted with planning and drafting the script and README content, followed by repository-specific adjustments.
- Prompt(s) used in this task workflow:
	- "Make a thorough plan for implementing the require actions in the attached document"
	- "write all this in a planning document and then we will walk through the steps to implement that task"
	- "ok, I made the scaffold and put the shebang in, start implementing the script features"
	- "yes, lets finish the last step"
