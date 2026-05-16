#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/_brain_train_common.sh"

mkdir -p "${brain_train_dataset_dir}"
echo "directory=${brain_train_dataset_dir}"
