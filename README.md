# Brain Trainer

Brain Trainer is the planned NymphsCore module for building local coding and
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
-> add trainer job
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

## Runtime Layout

Installed runtime path:

```text
~/Brain-Trainer
```

Generated runtime folders:

```text
~/Brain-Trainer/bin
~/Brain-Trainer/venv
~/Brain-Trainer/trainer
~/Brain-Trainer/sources
~/Brain-Trainer/datasets
~/Brain-Trainer/jobs
~/Brain-Trainer/adapters
~/Brain-Trainer/indexes
~/Brain-Trainer/config
~/Brain-Trainer/logs
```

These folders are local runtime state and should not be committed.

## Module Contract

Useful scripts:

```bash
scripts/install_brain_trainer.sh
scripts/brain_trainer_status.sh
scripts/brain_trainer_logs.sh
scripts/brain_trainer_uninstall.sh
```

`Logs` follows the Nymph module standard and prints:

```text
last_log=/home/nymph/Brain-Trainer/logs/brain-train.log
```

## Repo Rule

Keep this repo clean:

- commit module source, scripts, docs, UI, and pack definitions
- do not commit datasets, generated examples, jobs, adapters, indexes, venvs,
  model files, logs, secrets, or downloaded backend repos
