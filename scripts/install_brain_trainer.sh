#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/_brain_trainer_common.sh"

echo "Brain Trainer: preparing module runtime."
brain_trainer_init_dirs

if ! command -v python3 >/dev/null 2>&1; then
  echo "Installing Python..."
  sudo apt-get update
  sudo apt-get install -y python3 python3-venv python3-pip
fi

if [[ ! -x "${BRAIN_TRAINER_VENV_DIR}/bin/python" ]]; then
  echo "Creating Brain Trainer venv at ${BRAIN_TRAINER_VENV_DIR}..."
  python3 -m venv "${BRAIN_TRAINER_VENV_DIR}"
fi

mkdir -p "${BRAIN_TRAINER_INSTALL_ROOT}/scripts" "${BRAIN_TRAINER_INSTALL_ROOT}/ui" "${BRAIN_TRAINER_INSTALL_ROOT}/packs"
install -m 644 "${MODULE_ROOT}/nymph.json" "${BRAIN_TRAINER_INSTALL_ROOT}/nymph.json"
install -m 755 "${MODULE_ROOT}"/scripts/*.sh "${BRAIN_TRAINER_INSTALL_ROOT}/scripts/"
install -m 644 "${MODULE_ROOT}"/ui/*.html "${BRAIN_TRAINER_INSTALL_ROOT}/ui/"
install -m 644 "${MODULE_ROOT}"/packs/*.json "${BRAIN_TRAINER_INSTALL_ROOT}/packs/"

printf '%s\n' "${BRAIN_TRAINER_VERSION}" > "$(brain_trainer_marker)"

{
  printf '[%s] Brain Trainer installed at %s\n' "$(date -Is)" "${BRAIN_TRAINER_INSTALL_ROOT}"
  printf '[%s] Dataset builder is the next implementation milestone.\n' "$(date -Is)"
} >> "${BRAIN_TRAINER_LOG_FILE}"

echo "Brain Trainer installed."
echo "install_root=${BRAIN_TRAINER_INSTALL_ROOT}"
echo "version=${BRAIN_TRAINER_VERSION}"
echo "next_step=Build the dataset workflow before adding training backend support."
