#!/usr/bin/env bash
set -euo pipefail

required=(git terraform)
missing=0

for tool in "${required[@]}"; do
  if command -v "${tool}" >/dev/null 2>&1; then
    printf '%-12s %s\n' "${tool}" "$(command -v "${tool}")"
  else
    printf '%-12s %s\n' "${tool}" "MISSING"
    missing=1
  fi
done

if (( missing )); then
  echo "Install the missing tools, then run this script again." >&2
  exit 1
fi

terraform version | head -n 1
