#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/_brain_trainer_common.sh"

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
health=missing
detail="Not installed."
marker="$(brain_trainer_marker)"

if [[ -f "${marker}" ]]; then
  installed=true
  runtime_present=true
  version="$(head -n 1 "${marker}" 2>/dev/null || true)"
  [[ -n "${version}" ]] || version=unknown
  state=installed
  health=ok
  detail="brain-train installed. Dataset builder is the next milestone."
fi

if [[ -d "${BRAIN_TRAINER_DATASET_DIR}" ]]; then
  dataset_count="$(find "${BRAIN_TRAINER_DATASET_DIR}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d '[:space:]')"
fi

if [[ -d "${BRAIN_TRAINER_JOB_DIR}" ]]; then
  job_count="$(find "${BRAIN_TRAINER_JOB_DIR}" -mindepth 1 -maxdepth 1 \( -type f -o -type d \) 2>/dev/null | wc -l | tr -d '[:space:]')"
fi

if [[ -d "${BRAIN_TRAINER_ADAPTER_DIR}" ]]; then
  adapter_count="$(find "${BRAIN_TRAINER_ADAPTER_DIR}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d '[:space:]')"
fi

if [[ "${dataset_count}" != "0" || "${job_count}" != "0" || "${adapter_count}" != "0" ]] ||
   [[ -d "${BRAIN_TRAINER_CONFIG_DIR}" && -n "$(find "${BRAIN_TRAINER_CONFIG_DIR}" -mindepth 1 -print -quit 2>/dev/null)" ]] ||
   [[ -d "${BRAIN_TRAINER_LOG_DIR}" && -n "$(find "${BRAIN_TRAINER_LOG_DIR}" -mindepth 1 -print -quit 2>/dev/null)" ]]; then
  data_present=true
fi

if [[ -f "${BRAIN_INSTALL_ROOT}/.nymph-module-version" ]]; then
  brain_installed=true
fi

if [[ -f "${BRAIN_INSTALL_ROOT}/bin/lms-start" ]]; then
  configured_model="$(sed -n 's/^MODEL_KEY="\([^"]*\)".*/\1/p' "${BRAIN_INSTALL_ROOT}/bin/lms-start" | head -n 1)"
  if [[ -n "${configured_model}" && "${configured_model}" != "none" ]]; then
    brain_model_configured=true
    brain_local_model="${configured_model}"
  fi
fi

if [[ "${brain_installed}" == "true" ]] &&
   loaded_model="$(brain_trainer_probe_url "http://127.0.0.1:8000/v1/models" 2>/dev/null | python3 -c '
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

if [[ "${installed}" == "true" && "${brain_installed}" == "false" ]]; then
  state=needs_brain
  health=degraded
  detail="brain-train is installed, but Brain is not installed yet."
fi

cat <<EOF
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
install_root=${BRAIN_TRAINER_INSTALL_ROOT}
sources=${BRAIN_TRAINER_SOURCE_DIR}
datasets=${BRAIN_TRAINER_DATASET_DIR}
jobs=${BRAIN_TRAINER_JOB_DIR}
adapters=${BRAIN_TRAINER_ADAPTER_DIR}
indexes=${BRAIN_TRAINER_INDEX_DIR}
logs_dir=${BRAIN_TRAINER_LOG_DIR}
marker=${marker}
detail=${detail}
EOF
