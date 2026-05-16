#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/_brain_train_common.sh"

brain_train_init_dirs

echo "install_root=${brain_train_install_root}"
echo "logs_dir=${brain_train_log_dir}"
echo "last_log=${brain_train_log_file}"

if [[ "${brain_train_log_lines:-0}" =~ ^[0-9]+$ && "${brain_train_log_lines:-0}" -gt 0 ]]; then
  tail -n "${brain_train_log_lines}" "${brain_train_log_file}"
fi
