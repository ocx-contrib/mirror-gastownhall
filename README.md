# mirror-gastownhall

OCX mirrors for tools published by [Gas Town Hall](https://github.com/gastownhall).
One repository, one spec directory per package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [Beads](https://github.com/gastownhall/beads) | [`beads/mirror.yml`](beads/mirror.yml) | `ghcr.io/ocx-contrib/gastownhall/beads` | [`ocx.sh/gastownhall/beads`](https://index.ocx.sh/gastownhall/beads) | `MIT` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, then announced
into the OCX index.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
beads/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.svg / logo.png describe assets, 512px PNG
└── tests/smoke.star    Starlark smoke test
```

⚠️ `extends:` is a **shallow** merge of top-level keys — restate a block in
full or not at all. `platforms:` lives in each spec, never in the base.

## Notes on beads

- Linux builds are **glibc-dynamic** (cgo, embedded Dolt; GLIBC_2.34 floor) →
  `+libc.glibc` keys, ubuntu + fedora container legs, no alpine.
- `versions.min` is `1.0.1`: v1.0.0 linux/amd64 alone links `libicui18n.so.74`.
- windows/arm64 is a cgo-free upstream build (no embedded Dolt); its smoke leg
  asserts liveness and version only.

## Editing

```bash
direnv allow                                   # pinned toolchain onto PATH
ocx-mirror package validate beads/mirror.yml
ocx-mirror package pipeline generate ci --spec beads/mirror.yml   # name EVERY spec
```

Never hand-edit `.github/workflows/mirror-*.yml` / `describe-*.yml` etc. —
`verify-generated.yml` fails CI on drift.
