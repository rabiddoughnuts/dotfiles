#!/usr/bin/env bash
#
# Install AWS CLI v2 using AWS's Linux zip bundle plus apt-managed prerequisites.
# General use:
# - Run manually on apt-based Linux systems when you want a guarded AWS CLI install.
# - Requires root because it installs packages and writes into system locations.
# - Stops early if an `aws` command already exists so it does not replace current behavior.
#
# Environment assumptions:
# - Debian/Ubuntu-style system with apt/apt-get available.
# - x86_64 Linux target, because the download URL is the AWS x86_64 bundle.
#
set -euo pipefail

AWS_ZIP_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

# This installer intentionally requires root up front instead of prompting mid-run.
if [[ "${EUID}" -ne 0 ]]; then
	echo "Error: this script must be run as root (use sudo)."
	exit 1
fi

# The dependency bootstrap is apt-based, so fail clearly on non-apt systems.
if ! command -v apt >/dev/null 2>&1; then
	echo "Error: apt package manager is required to run this installer."
	exit 1
fi

cat <<'INFO'
This script will install:
- AWS Command Line Interface (AWS CLI)
- Prerequisites via apt: curl, unzip

Installation is non-interactive and quiet.
INFO

# Keep the install explicit and user-confirmed even though the package steps are non-interactive.
read -r -p "Continue with installation? (y/n): " confirm
case "${confirm}" in
	y|Y)
		;;
	n|N)
		echo "Install cancelled by user."
		exit 0
		;;
	*)
		echo "Invalid response. Please rerun and enter y or n."
		exit 1
		;;
esac

# Avoid shadowing an existing aws command from another install method.
if command -v aws >/dev/null 2>&1; then
	echo "Error: command name conflict. 'aws' already exists on this system."
	echo "To avoid changing current behavior, installation has been stopped."
	exit 1
fi

# Use a temp workspace and clean it automatically so the zip payload is not left behind.
tmp_dir="$(mktemp -d)"
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

# Quiet apt usage keeps the script output focused on the major installer stages.
echo "Installing prerequisites with apt..."
DEBIAN_FRONTEND=noninteractive apt-get update -qq >/dev/null
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq curl unzip >/dev/null

# Download the official bundle, unpack it, then hand off to AWS's installer.
echo "Downloading AWS CLI installer..."
curl -fsSL "${AWS_ZIP_URL}" -o "${tmp_dir}/awscliv2.zip"

echo "Extracting installer..."
unzip -q "${tmp_dir}/awscliv2.zip" -d "${tmp_dir}"

echo "Running AWS CLI installer..."
"${tmp_dir}/aws/install" >/dev/null

echo "Install complete."
echo "Test it with: aws --version"
