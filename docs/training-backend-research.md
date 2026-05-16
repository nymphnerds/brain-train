# brain-train Training Backend Research

Research snapshot: 2026-05-16

This is the full research queue for local LLM adapter training backends. It is
not a final implementation decision. The goal is to keep every serious option
visible while still giving the first proof a clear path.

## Current Recommendation

Use llama-factory for the first proof.

Why:

- it has CLI and WebUI paths
- it supports LoRA/QLoRA workflows
- it is faster to prove brain-train's product flow than a lower-level library
- it can stay behind module-owned scripts and status files

Keep axolotl as the likely serious config-driven backend after the first proof.
Keep unsloth as the low-VRAM/speed path to test once the basic workflow is
stable.

## Research Queue

| option | why research it | likely role |
| --- | --- | --- |
| llama-factory | broad local LLM/VLM fine-tuning project with CLI and WebUI paths, LoRA/QLoRA support, and many model families | first proof |
| axolotl | strong YAML/config-driven local LLM fine-tuning stack with LoRA/QLoRA and preference methods | serious backend candidate |
| unsloth | optimized local fine-tuning path focused on speed and lower VRAM | consumer GPU mode |
| trl plus peft | Hugging Face lower-level path for SFT, preference methods, and adapter control | custom backend path |
| torchtune | PyTorch-native recipes, including LoRA examples, with less product wrapper magic | clean lower-level path |
| litgpt | Lightning AI project with LoRA/QLoRA recipes and deploy/fine-tune tooling | simple scriptable alternative |
| ms-swift | ModelScope stack with many model families and multimodal coverage | broad model compatibility research |
| xtuner | InternLM ecosystem option with efficient fine-tuning support and large-model focus | research for specific model families |
| autotrain | Hugging Face no-code/local-capable path with PEFT and int4 settings | beginner workflow comparison |
| ludwig | config-driven LLM fine-tuning and preference learning | config/product comparison |
| text-generation-webui | local offline UI with LoRA training support | UI reference only, not first backend |
| nvidia nemo | NVIDIA stack with PEFT/LoRA support and enterprise-scale workflow | later large-GPU research |
| openrlhf | scalable RLHF/DPO/PPO style stack with LoRA/QLoRA support | later alignment research |
| verl | RL post-training stack for PPO/GRPO and agentic learning research | later alignment research |
| original qlora repo | reference implementation and paper code for the QLoRA method | reference only |
| ai toolkit | strong diffusion image/video LoRA project, but not aimed at LLM adapter training for Brain | do not use for v0.1 |

## What To Test For Each Option

For every candidate that reaches hands-on testing, capture:

- WSL install steps and failure points
- CUDA/PyTorch version requirements
- minimum practical VRAM for tiny proof runs
- whether it can train a tiny adapter from JSONL without cloud services
- supported model families, especially Qwen, Llama, Mistral, Gemma, and DeepSeek
- exact dataset schema expected by the backend
- output adapter format and whether Brain can consume or convert it
- whether jobs can be started/stopped/polled cleanly from shell scripts
- where logs, checkpoints, caches, and final adapters are written
- whether it downloads base models during install or only during explicit jobs
- whether it can run fully local after dependencies and models are present

## First Proof Shape

The first proof should be deliberately small:

```text
tiny reviewed jsonl dataset
-> llama-factory config
-> tiny local LoRA/QLoRA run
-> adapter output under /home/nymph/brain-train/adapters
-> metadata written as nymphs_brain_adapter.json
-> Brain can report or load the adapter path
```

Do not wire all candidates into the UI for v0.1. Prove one route first, then
turn the rest of this document into measured implementation notes.

## Source Links

- ai toolkit: https://github.com/ostris/ai-toolkit
- llama-factory: https://github.com/hiyouga/LLaMA-Factory
- axolotl: https://docs.axolotl.ai/
- unsloth: https://docs.unsloth.ai/get-started/fine-tuning-guide
- trl: https://huggingface.co/docs/trl/main/en/index
- peft: https://huggingface.co/docs/peft/index
- torchtune: https://meta-pytorch.org/torchtune/stable/tutorials/lora_finetune.html
- litgpt: https://github.com/Lightning-AI/litgpt
- ms-swift: https://github.com/modelscope/ms-swift
- xtuner: https://github.com/InternLM/xtuner
- autotrain: https://huggingface.co/docs/autotrain/main/tasks/llm_finetuning
- ludwig: https://ludwig.ai/latest/user_guide/llms/finetuning/
- text-generation-webui: https://github.com/oobabooga/text-generation-webui
- nvidia nemo: https://docs.nvidia.com/nemo-framework/
- openrlhf: https://openrlhf.readthedocs.io/
- verl: https://github.com/volcengine/verl
- qlora reference: https://github.com/artidoro/qlora
