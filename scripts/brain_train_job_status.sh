#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/_brain_train_common.sh"

echo "job_exists=false"
echo "job_status=not_implemented"
echo "progress_current=0"
echo "progress_total=0"
echo "progress_percent=0"
echo "progress_text=Dataset builder is the next milestone."
echo "adapter_exists=false"
echo "log_available=false"
echo "log_tail_json=\"\""
