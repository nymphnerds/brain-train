# brain-train

brain-train is the planned NymphsCore module for building local coding and
game-development LoRA/QLoRA adapters for Brain.

This repo is intentionally the clean module source. It is not a dump of a live
runtime folder.

## Goal

Turn selected codebases, docs, and engine-specific source material into reviewed
training datasets, then train local LLM adapters that Brain can use alongside
project retrieval/indexes.

The intended long-term flow:

```text
pick Brain/base model
-> add source folders and docs
-> build reviewed instruction dataset
-> add training job
-> start/stop/delete/poll job
-> save finished adapter
-> install/link adapter into Brain
```

## Current State

This is an initial module skeleton. It provides:

- `nymph.json`
- install/status/logs/uninstall scripts
- safe runtime folder layout
- placeholder Manager UI
- engine pack placeholders
- planning handoff docs

Training backend integration is not implemented yet. The first real milestone
is the dataset builder, not model training.

## Backend Direction

Research snapshot from 2026-05-16:

- do not use ai toolkit for this module; it is aimed at diffusion image/video
  LoRA workflows, not local LLM adapter work for Brain
- use llama-factory for the first local proof because it has CLI and WebUI
  paths, supports LoRA/QLoRA, and is closer to the simple module workflow
- keep axolotl as the stronger config-driven backend candidate after the first
  proof works
- keep unsloth as the low-VRAM/speed path to test after the core workflow is
  stable
- keep the full candidate list in
  `docs/training-backend-research.md` so every option can be researched

Reference links:

- https://github.com/ostris/ai-toolkit
- https://github.com/hiyouga/LLaMA-Factory
- https://docs.axolotl.ai/
- https://docs.unsloth.ai/get-started/fine-tuning-guide
- https://huggingface.co/docs/trl/main/en/index
- https://huggingface.co/docs/peft/index
- https://meta-pytorch.org/torchtune/stable/tutorials/lora_finetune.html

## Runtime Layout

Installed runtime path:

```text
~/brain-train
```

Generated runtime folders:

```text
~/brain-train/bin
~/brain-train/venv
~/brain-train/backend
~/brain-train/sources
~/brain-train/datasets
~/brain-train/jobs
~/brain-train/adapters
~/brain-train/indexes
~/brain-train/config
~/brain-train/logs
```

These folders are local runtime state and should not be committed.

## Module Contract

Useful scripts:

```bash
scripts/install_brain_train.sh
scripts/brain_train_status.sh
scripts/brain_train_logs.sh
scripts/brain_train_uninstall.sh
```

`Logs` follows the Nymph module standard and prints:

```text
last_log=/home/nymph/brain-train/logs/brain-train.log
```

## Repo Rule

Keep this repo clean:

- commit module source, scripts, docs, UI, and pack definitions
- do not commit datasets, generated examples, jobs, adapters, indexes, venvs,
  model files, logs, secrets, or downloaded backend repos
