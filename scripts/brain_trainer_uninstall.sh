#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/_brain_trainer_common.sh"

DRY_RUN=false
CONFIRM=false
PURGE=false
DATA_ONLY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --yes) CONFIRM=true; shift ;;
    --purge) PURGE=true; shift ;;
    --data-only) DATA_ONLY=true; shift ;;
    *)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
  esac
done

echo "brain-train uninstall plan"
echo "install_root=${BRAIN_TRAINER_INSTALL_ROOT}"

if [[ "${DATA_ONLY}" == "true" ]]; then
  targets=(
    "${BRAIN_TRAINER_SOURCE_DIR}"
    "${BRAIN_TRAINER_DATASET_DIR}"
    "${BRAIN_TRAINER_JOB_DIR}"
    "${BRAIN_TRAINER_ADAPTER_DIR}"
    "${BRAIN_TRAINER_INDEX_DIR}"
    "${BRAIN_TRAINER_CONFIG_DIR}"
    "${BRAIN_TRAINER_LOG_DIR}"
  )
elif [[ "${PURGE}" == "true" ]]; then
  targets=("${BRAIN_TRAINER_INSTALL_ROOT}")
else
  targets=(
    "${BRAIN_TRAINER_BIN_DIR}"
    "${BRAIN_TRAINER_VENV_DIR}"
    "${BRAIN_TRAINER_BACKEND_DIR}"
    "${BRAIN_TRAINER_INSTALL_ROOT}/scripts"
    "${BRAIN_TRAINER_INSTALL_ROOT}/ui"
    "${BRAIN_TRAINER_INSTALL_ROOT}/packs"
    "${BRAIN_TRAINER_INSTALL_ROOT}/nymph.json"
    "$(brain_trainer_marker)"
  )
fi

for target in "${targets[@]}"; do
  echo "delete=${target}"
done

if [[ "${DRY_RUN}" == "true" ]]; then
  exit 0
fi

if [[ "${CONFIRM}" != "true" ]]; then
  echo "Pass --yes to apply this uninstall plan." >&2
  exit 2
fi

for target in "${targets[@]}"; do
  rm -rf "${target}"
done

echo "brain-train uninstall complete."
