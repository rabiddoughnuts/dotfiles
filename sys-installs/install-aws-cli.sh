#!/usr/bin/env bash
set -euo pipefail

AWS_ZIP_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

if [[ "${EUID}" -ne 0 ]]; then
	echo "Error: this script must be run as root (use sudo)."
	exit 1
fi

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

if command -v aws >/dev/null 2>&1; then
	echo "Error: command name conflict. 'aws' already exists on this system."
	echo "To avoid changing current behavior, installation has been stopped."
	exit 1
fi

tmp_dir="$(mktemp -d)"
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

echo "Installing prerequisites with apt..."
DEBIAN_FRONTEND=noninteractive apt update -qq >/dev/null
DEBIAN_FRONTEND=noninteractive apt install -y -qq curl unzip >/dev/null

echo "Downloading AWS CLI installer..."
curl -fsSL "${AWS_ZIP_URL}" -o "${tmp_dir}/awscliv2.zip"

echo "Extracting installer..."
unzip -q "${tmp_dir}/awscliv2.zip" -d "${tmp_dir}"

echo "Running AWS CLI installer..."
"${tmp_dir}/aws/install" >/dev/null

echo "Install complete."
echo "Test it with: aws --version"

