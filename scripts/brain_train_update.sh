#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/_brain_train_common.sh"

if [[ ! -f "$(brain_train_marker)" ]]; then
  "${script_dir}/install_brain_train.sh"
  exit $?
fi

brain_train_init_dirs
mkdir -p "${brain_train_install_root}/scripts" "${brain_train_install_root}/ui" "${brain_train_install_root}/packs"
install -m 644 "${module_root}/nymph.json" "${brain_train_install_root}/nymph.json"
install -m 755 "${module_root}"/scripts/*.sh "${brain_train_install_root}/scripts/"
install -m 644 "${module_root}"/ui/*.html "${brain_train_install_root}/ui/"
install -m 644 "${module_root}"/packs/*.json "${brain_train_install_root}/packs/"
printf '%s\n' "${brain_train_version}" > "$(brain_train_marker)"

echo "brain-train module files updated."
echo "install_root=${brain_train_install_root}"
echo "version=${brain_train_version}"
