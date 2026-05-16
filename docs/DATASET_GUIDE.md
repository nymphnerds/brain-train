# Brain Trainer Dataset Guide

Brain Trainer's first real milestone is dataset generation and review.

The dataset builder should turn selected source folders into small, auditable
instruction examples before any model training happens.

## First Supported Inputs

Useful file types:

```text
.cs
.cpp
.c
.h
.hpp
.py
.gd
.ts
.js
.jsx
.tsx
.json
.yaml
.yml
.toml
.ini
.md
.txt
.uproject
.uplugin
.csproj
.sln
```

Ignore runtime/build/cache/binary folders by default:

```text
.git
node_modules
bin
obj
Build
Binaries
DerivedDataCache
Intermediate
Library
Temp
.vs
.vscode
venv
.venv
__pycache__
dist
out
coverage
```

## First Output Shape

```text
raw_manifest.json
examples.jsonl
dataset_report.json
```

Examples should use chat/instruction format with source metadata:

```json
{
  "messages": [
    {
      "role": "system",
      "content": "You are a local game-development coding assistant."
    },
    {
      "role": "user",
      "content": "Explain this source file."
    },
    {
      "role": "assistant",
      "content": "..."
    }
  ],
  "source": {
    "path": "Source/MyGame/FooComponent.cpp",
    "engine": "unreal",
    "language": "cpp",
    "pack": "unreal"
  }
}
```

## Rule

Bad training data is worse than no training data. Keep the generated dataset
small enough to review before training.
