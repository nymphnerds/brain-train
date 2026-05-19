#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/_brain_train_common.sh"

installed=false
runtime_present=false
data_present=false
brain_installed=false
brain_model_configured=false
brain_llm_running=false
brain_local_model="none"
backend_ready=false
dataset_count=0
job_count=0
adapter_count=0
version=not-installed
state=available
health=unavailable
detail="Not installed."
marker="$(brain_train_marker)"

if [[ -f "${marker}" ]]; then
  installed=true
  runtime_present=true
  version="$(head -n 1 "${marker}" 2>/dev/null || true)"
  [[ -n "${version}" ]] || version=unknown
  state=installed
  health=ok
  detail="brain-train installed. Dataset builder is the next milestone."
fi

if [[ -d "${brain_train_dataset_dir}" ]]; then
  dataset_count="$(find "${brain_train_dataset_dir}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d '[:space:]')"
fi

if [[ -d "${brain_train_job_dir}" ]]; then
  job_count="$(find "${brain_train_job_dir}" -mindepth 1 -maxdepth 1 \( -type f -o -type d \) 2>/dev/null | wc -l | tr -d '[:space:]')"
fi

if [[ -d "${brain_train_adapter_dir}" ]]; then
  adapter_count="$(find "${brain_train_adapter_dir}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d '[:space:]')"
fi

if [[ "${dataset_count}" != "0" || "${job_count}" != "0" || "${adapter_count}" != "0" ]] ||
   [[ -d "${brain_train_config_dir}" && -n "$(find "${brain_train_config_dir}" -mindepth 1 -print -quit 2>/dev/null)" ]] ||
   [[ -d "${brain_train_log_dir}" && -n "$(find "${brain_train_log_dir}" -mindepth 1 -print -quit 2>/dev/null)" ]]; then
  data_present=true
fi

if [[ "${installed}" == "true" ]]; then
  if [[ -f "${brain_install_root}/.nymph-module-version" ]]; then
    brain_installed=true
  fi

  if [[ -f "${brain_install_root}/bin/lms-start" ]]; then
    configured_model="$(sed -n 's/^MODEL_KEY="\([^"]*\)".*/\1/p' "${brain_install_root}/bin/lms-start" | head -n 1)"
    if [[ -n "${configured_model}" && "${configured_model}" != "none" ]]; then
      brain_model_configured=true
      brain_local_model="${configured_model}"
    fi
  fi

  if [[ "${brain_installed}" == "true" ]] &&
     loaded_model="$(brain_train_probe_url "http://127.0.0.1:8000/v1/models" 2>/dev/null | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    raise SystemExit(0)
models = data.get("data") if isinstance(data, dict) else None
if isinstance(models, list) and models:
    first = models[0]
    if isinstance(first, dict):
        print(first.get("id") or first.get("name") or first.get("model") or "")
')"; then
    if [[ -n "${loaded_model}" ]]; then
      brain_llm_running=true
      brain_local_model="${loaded_model}"
    fi
  fi
fi

if [[ "${installed}" == "true" && "${brain_installed}" == "false" ]]; then
  state=needs_brain
  health=degraded
  detail="brain-train is installed, but Brain is not installed yet."
fi

cat <<eof
id=brain-train
name=brain-train
installed=${installed}
runtime_present=${runtime_present}
data_present=${data_present}
version=${version}
running=false
state=${state}
health=${health}
backend=axolotl
backend_ready=${backend_ready}
brain_installed=${brain_installed}
brain_model_configured=${brain_model_configured}
brain_llm_running=${brain_llm_running}
brain_local_model=${brain_local_model}
dataset_count=${dataset_count}
job_count=${job_count}
adapter_count=${adapter_count}
active_state=idle
active_info=No brain-train job runner implemented yet.
install_root=${brain_train_install_root}
sources=${brain_train_source_dir}
datasets=${brain_train_dataset_dir}
jobs=${brain_train_job_dir}
adapters=${brain_train_adapter_dir}
indexes=${brain_train_index_dir}
logs_dir=${brain_train_log_dir}
marker=${marker}
detail=${detail}
eof
