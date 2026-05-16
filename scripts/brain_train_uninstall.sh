#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/_brain_train_common.sh"

dry_run=false
confirm=false
purge=false
data_only=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) dry_run=true; shift ;;
    --yes) confirm=true; shift ;;
    --purge) purge=true; shift ;;
    --data-only) data_only=true; shift ;;
    *)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
  esac
done

echo "brain-train uninstall plan"
echo "install_root=${brain_train_install_root}"

if [[ "${data_only}" == "true" ]]; then
  targets=(
    "${brain_train_source_dir}"
    "${brain_train_dataset_dir}"
    "${brain_train_job_dir}"
    "${brain_train_adapter_dir}"
    "${brain_train_index_dir}"
    "${brain_train_config_dir}"
    "${brain_train_log_dir}"
  )
elif [[ "${purge}" == "true" ]]; then
  targets=("${brain_train_install_root}")
else
  targets=(
    "${brain_train_bin_dir}"
    "${brain_train_venv_dir}"
    "${brain_train_backend_dir}"
    "${brain_train_install_root}/scripts"
    "${brain_train_install_root}/ui"
    "${brain_train_install_root}/packs"
    "${brain_train_install_root}/nymph.json"
    "$(brain_train_marker)"
  )
fi

for target in "${targets[@]}"; do
  echo "delete=${target}"
done

if [[ "${dry_run}" == "true" ]]; then
  exit 0
fi

if [[ "${confirm}" != "true" ]]; then
  echo "Pass --yes to apply this uninstall plan." >&2
  exit 2
fi

for target in "${targets[@]}"; do
  rm -rf "${target}"
done

echo "brain-train uninstall complete."
