#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/_brain_trainer_common.sh"

mkdir -p "${BRAIN_TRAINER_ADAPTER_DIR}"
echo "directory=${BRAIN_TRAINER_ADAPTER_DIR}"
