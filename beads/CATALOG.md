---
title: Beads
description: Git-friendly issue tracker with first-class dependencies, built as memory for coding agents
keywords: beads,bd,issue-tracker,agents,ai,dependencies,dolt,task-graph,memory
---

# Beads

Beads (`bd`) is a lightweight issue tracker designed as long-term memory for
coding agents. Issues live next to your code in a version-controlled
[Dolt](https://www.dolthub.com/) database, carry first-class dependencies,
and expose a computed work queue — `bd ready` lists exactly the issues whose
blockers are closed, so an agent always knows what it can pick up next.

Every command speaks `--json`, ids are short hashes that merge cleanly across
branches and machines, and `bd prime` / `bd setup <tool>` wire the tracker
into Claude Code, Codex, Cursor and other agents.

## What's included

- **bd** — the single binary: issue CRUD (`create`, `q`, `update`, `close`,
  `show`, `list`), dependency graph (`dep`, `ready`, `blocked`), sync and
  history via Dolt remotes, and agent integration (`prime`, `setup`). The Dolt
  engine is embedded — no database server needed.

## Notes

- `bd init` creates a git repository in the current directory unless one
  exists or `BEADS_DIR` is set, so `git` must be on `PATH` for the default
  flow.
- The **windows/arm64** build is compiled without cgo upstream and has no
  embedded Dolt engine; it works only against an external `dolt sql-server`
  (`bd init --server`).
- bd sends anonymous usage metrics by default; opt out with `bd metrics off`
  or `BD_DISABLE_METRICS=1`.

## Links

- [Beads documentation](https://beads.gascity.com)
- [Beads on GitHub](https://github.com/gastownhall/beads)
