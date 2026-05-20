#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/_brain_train_common.sh"

echo "brain-train: preparing module runtime."
brain_train_init_dirs

if ! command -v python3 >/dev/null 2>&1; then
  echo "Installing Python..."
  sudo apt-get update
  sudo apt-get install -y python3 python3-venv python3-pip
fi

if ! python3 - <<'PY' >/dev/null 2>&1; then
import ensurepip
import venv
PY
  echo "Installing Python venv/pip tooling..."
  sudo apt-get update
  sudo apt-get install -y python3-venv python3-pip
fi

if [[ -d "${brain_train_venv_dir}" ]] && {
  [[ ! -x "${brain_train_venv_dir}/bin/python" ]] ||
  ! "${brain_train_venv_dir}/bin/python" -m pip --version >/dev/null 2>&1
}; then
  echo "Removing incomplete brain-train venv at ${brain_train_venv_dir}..."
  rm -rf "${brain_train_venv_dir}"
fi

if [[ ! -x "${brain_train_venv_dir}/bin/python" ]]; then
  echo "Creating brain-train venv at ${brain_train_venv_dir}..."
  python3 -m venv "${brain_train_venv_dir}"
fi

if ! "${brain_train_venv_dir}/bin/python" -m pip --version >/dev/null 2>&1; then
  echo "Bootstrapping pip in brain-train venv..."
  "${brain_train_venv_dir}/bin/python" -m ensurepip --upgrade
fi

if ! "${brain_train_venv_dir}/bin/python" -m pip --version >/dev/null 2>&1; then
  echo "brain-train venv is missing pip after bootstrap. Repair Python venv tooling and retry." >&2
  exit 1
fi

mkdir -p "${brain_train_install_root}/scripts" "${brain_train_install_root}/ui" "${brain_train_install_root}/packs"
install -m 644 "${module_root}/nymph.json" "${brain_train_install_root}/nymph.json"
install -m 755 "${module_root}"/scripts/*.sh "${brain_train_install_root}/scripts/"
install -m 644 "${module_root}"/ui/*.html "${brain_train_install_root}/ui/"
install -m 644 "${module_root}"/packs/*.json "${brain_train_install_root}/packs/"

printf '%s\n' "${brain_train_version}" > "$(brain_train_marker)"

{
  printf '[%s] brain-train installed at %s\n' "$(date -Is)" "${brain_train_install_root}"
  printf '[%s] Dataset builder is the next implementation milestone.\n' "$(date -Is)"
} >> "${brain_train_log_file}"

echo "brain-train installed."
echo "install_root=${brain_train_install_root}"
echo "version=${brain_train_version}"
echo "next_step=Build the dataset workflow before adding training backend support."
