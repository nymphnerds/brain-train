# Brain Integration Guide

Brain Trainer should integrate with Brain carefully.

First version should not rewrite Brain startup scripts or silently change the
selected Brain model.

## Preferred First Integration

Brain Trainer owns adapter outputs under:

```text
/home/nymph/Brain-Trainer/adapters
```

`Install Into Brain` should write a small descriptor that Brain can learn to
read later, for example:

```text
/home/nymph/Nymphs-Brain/config/adapters.json
```

Suggested adapter metadata:

```json
{
  "id": "my_project_coder",
  "name": "My Project Coder",
  "base_model": "selected Brain local model",
  "adapter_path": "/home/nymph/Brain-Trainer/adapters/my_project_coder",
  "dataset_path": "/home/nymph/Brain-Trainer/datasets/my_project_coder/review.jsonl",
  "index_path": "/home/nymph/Brain-Trainer/indexes/my_project_coder",
  "engine_pack": "unreal"
}
```

## Adapter Plus Index

For codebases, use both:

```text
adapter -> style, behavior, conventions, common patterns
index   -> exact current code/docs/project facts
```

Do not pretend fine-tuning alone replaces retrieval.
