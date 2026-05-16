#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/_brain_trainer_common.sh"

brain_trainer_init_dirs

echo "install_root=${BRAIN_TRAINER_INSTALL_ROOT}"
echo "logs_dir=${BRAIN_TRAINER_LOG_DIR}"
echo "last_log=${BRAIN_TRAINER_LOG_FILE}"

if [[ "${BRAIN_TRAINER_LOG_LINES:-0}" =~ ^[0-9]+$ && "${BRAIN_TRAINER_LOG_LINES:-0}" -gt 0 ]]; then
  tail -n "${BRAIN_TRAINER_LOG_LINES}" "${BRAIN_TRAINER_LOG_FILE}"
fi
