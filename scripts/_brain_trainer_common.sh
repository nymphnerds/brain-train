#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

BRAIN_TRAINER_INSTALL_ROOT="${BRAIN_TRAINER_INSTALL_ROOT:-${NYMPHS_BRAIN_TRAINER_INSTALL_ROOT:-$HOME/brain-train}}"
BRAIN_TRAINER_BIN_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/bin"
BRAIN_TRAINER_VENV_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/venv"
BRAIN_TRAINER_BACKEND_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/trainer"
BRAIN_TRAINER_SOURCE_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/sources"
BRAIN_TRAINER_DATASET_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/datasets"
BRAIN_TRAINER_JOB_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/jobs"
BRAIN_TRAINER_ADAPTER_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/adapters"
BRAIN_TRAINER_INDEX_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/indexes"
BRAIN_TRAINER_CONFIG_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/config"
BRAIN_TRAINER_LOG_DIR="${BRAIN_TRAINER_INSTALL_ROOT}/logs"
BRAIN_TRAINER_LOG_FILE="${BRAIN_TRAINER_LOG_DIR}/brain-train.log"
BRAIN_TRAINER_VERSION="0.1.0"

BRAIN_INSTALL_ROOT="${BRAIN_INSTALL_ROOT:-${NYMPHS_BRAIN_INSTALL_ROOT:-$HOME/Nymphs-Brain}}"

brain_trainer_init_dirs() {
  mkdir -p \
    "${BRAIN_TRAINER_BIN_DIR}" \
    "${BRAIN_TRAINER_VENV_DIR}" \
    "${BRAIN_TRAINER_BACKEND_DIR}" \
    "${BRAIN_TRAINER_SOURCE_DIR}" \
    "${BRAIN_TRAINER_DATASET_DIR}" \
    "${BRAIN_TRAINER_JOB_DIR}" \
    "${BRAIN_TRAINER_ADAPTER_DIR}" \
    "${BRAIN_TRAINER_INDEX_DIR}" \
    "${BRAIN_TRAINER_CONFIG_DIR}" \
    "${BRAIN_TRAINER_LOG_DIR}"
  touch "${BRAIN_TRAINER_LOG_FILE}"
}

brain_trainer_marker() {
  printf '%s/.nymph-module-version\n' "${BRAIN_TRAINER_INSTALL_ROOT}"
}

brain_trainer_probe_url() {
  local url="${1}"
  python3 - "${url}" <<'PY'
import sys
from urllib.request import urlopen

try:
    with urlopen(sys.argv[1], timeout=2) as response:
        print(response.read().decode("utf-8", errors="replace"))
except Exception as exc:
    raise SystemExit(str(exc))
PY
}
