# sys-installs

This directory contains one-off system software installers that are meant to be run intentionally, with safeguards, rather than as part of the private-state capture/restore workflow.

## Files

- `install-aws-cli.sh`: Installs AWS CLI v2 using apt-managed prerequisites and the official AWS Linux zip bundle.

## What It Does

`install-aws-cli.sh`:

- Requires root from the start.
- Verifies that `apt` exists before it does any work.
- Prompts for a simple `y`/`n` confirmation before installing.
- Refuses to continue if an `aws` command already exists.
- Installs `curl` and `unzip` with `apt-get`.
- Downloads the official AWS CLI v2 Linux installer zip, extracts it, and runs the bundled installer.
- Cleans up its temporary working directory automatically.

## How It Works

1. Checks that the script is running as root.
2. Verifies the system has `apt`.
3. Prints a short install summary and waits for confirmation.
4. Stops if `aws` is already present on the machine.
5. Creates a temporary directory and registers cleanup with `trap`.
6. Installs prerequisites with quiet, non-interactive `apt-get` calls.
7. Downloads and extracts the AWS CLI bundle.
8. Runs the AWS installer and prints a post-install verification hint.

## Usage

From the repository root:

```bash
chmod +x sys-installs/install-aws-cli.sh
sudo ./sys-installs/install-aws-cli.sh
```

## Verification

Run:

```bash
aws --version
```

If installation succeeded, this command prints the AWS CLI version.

If `aws` already exists on the system, the script intentionally exits with a command-name conflict message to avoid changing existing behavior.

## Environment Assumptions

- Assumes `bash`.
- Assumes a Debian/Ubuntu-style system with `apt` and `apt-get`.
- Assumes an `x86_64` Linux machine because the script hardcodes the AWS x86_64 download URL.
- Requires root or `sudo` because it installs packages and writes system files.

## Constraints And Caveats

- This installer is not Arch-oriented and is not portable to non-apt systems in its current form.
- It does not attempt upgrades or side-by-side installs; any existing `aws` command is treated as a hard stop.
- Network access is required both for `apt-get` and for downloading the AWS installer bundle.

## Sources and citations

- [AWS CLI official installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html): Used for the Linux zip installer workflow and verification command.
- [Ubuntu apt manual page](https://manpages.ubuntu.com/manpages/jammy/man8/apt.8.html): Used for apt command behavior and non-interactive package installation flags.
