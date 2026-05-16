#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
module_root="$(cd "${script_dir}/.." && pwd)"

brain_train_install_root="${brain_train_install_root:-${nymphs_brain_train_install_root:-$HOME/brain-train}}"
brain_train_bin_dir="${brain_train_install_root}/bin"
brain_train_venv_dir="${brain_train_install_root}/venv"
brain_train_backend_dir="${brain_train_install_root}/backend"
brain_train_source_dir="${brain_train_install_root}/sources"
brain_train_dataset_dir="${brain_train_install_root}/datasets"
brain_train_job_dir="${brain_train_install_root}/jobs"
brain_train_adapter_dir="${brain_train_install_root}/adapters"
brain_train_index_dir="${brain_train_install_root}/indexes"
brain_train_config_dir="${brain_train_install_root}/config"
brain_train_log_dir="${brain_train_install_root}/logs"
brain_train_log_file="${brain_train_log_dir}/brain-train.log"
brain_train_version="0.1.0"

brain_install_root="${brain_install_root:-${nymphs_brain_install_root:-$HOME/Nymphs-Brain}}"

brain_train_init_dirs() {
  mkdir -p \
    "${brain_train_bin_dir}" \
    "${brain_train_venv_dir}" \
    "${brain_train_backend_dir}" \
    "${brain_train_source_dir}" \
    "${brain_train_dataset_dir}" \
    "${brain_train_job_dir}" \
    "${brain_train_adapter_dir}" \
    "${brain_train_index_dir}" \
    "${brain_train_config_dir}" \
    "${brain_train_log_dir}"
  touch "${brain_train_log_file}"
}

brain_train_marker() {
  printf '%s/.nymph-module-version\n' "${brain_train_install_root}"
}

brain_train_probe_url() {
  local url="${1}"
  python3 - "${url}" <<'py'
import sys
from urllib.request import urlopen

try:
    with urlopen(sys.argv[1], timeout=2) as response:
        print(response.read().decode("utf-8", errors="replace"))
except Exception as exc:
    raise SystemExit(str(exc))
py
}
