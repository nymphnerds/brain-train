#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/_brain_trainer_common.sh"

if [[ ! -f "$(brain_trainer_marker)" ]]; then
  "${SCRIPT_DIR}/install_brain_trainer.sh"
  exit $?
fi

brain_trainer_init_dirs
mkdir -p "${BRAIN_TRAINER_INSTALL_ROOT}/scripts" "${BRAIN_TRAINER_INSTALL_ROOT}/ui" "${BRAIN_TRAINER_INSTALL_ROOT}/packs"
install -m 644 "${MODULE_ROOT}/nymph.json" "${BRAIN_TRAINER_INSTALL_ROOT}/nymph.json"
install -m 755 "${MODULE_ROOT}"/scripts/*.sh "${BRAIN_TRAINER_INSTALL_ROOT}/scripts/"
install -m 644 "${MODULE_ROOT}"/ui/*.html "${BRAIN_TRAINER_INSTALL_ROOT}/ui/"
install -m 644 "${MODULE_ROOT}"/packs/*.json "${BRAIN_TRAINER_INSTALL_ROOT}/packs/"
printf '%s\n' "${BRAIN_TRAINER_VERSION}" > "$(brain_trainer_marker)"

echo "Brain Trainer module files updated."
echo "install_root=${BRAIN_TRAINER_INSTALL_ROOT}"
echo "version=${BRAIN_TRAINER_VERSION}"
