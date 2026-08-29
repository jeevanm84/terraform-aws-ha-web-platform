#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
learning_dir="${repo_root}/environments/learning"

if ! command -v terraform >/dev/null 2>&1; then
  echo "ERROR: Terraform is required. Install version 1.10 or newer." >&2
  exit 1
fi

echo "==> Checking Terraform formatting"
terraform -chdir="${repo_root}" fmt -check -recursive

echo "==> Initializing providers without a remote backend"
terraform -chdir="${learning_dir}" init -backend=false -input=false

echo "==> Validating the learning environment"
terraform -chdir="${learning_dir}" validate

echo "==> Running mocked Terraform tests (no AWS account required)"
terraform -chdir="${learning_dir}" test

echo "All offline checks passed. No AWS resources were created."
