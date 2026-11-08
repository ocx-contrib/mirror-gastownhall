# beads/tests/smoke.star — hermetic, offline, asserts the contract.
#
# Workspace: BEADS_DIR points bd at a .beads/ under scratch. That also makes
# `bd init` skip its `git init` (cmd/bd/init.go: skipped when BEADS_DIR is
# set), so the stock ubuntu/fedora container legs need no git. Verified on
# v1.0.1 and v1.3.4 with PATH holding nothing but bd.
# BD_DISABLE_METRICS: upstream sends anonymous usage metrics by default.
BD = "bd.exe" if ocx.target_platform.os == ocx.os.Windows else "bd"
ENV = {
    "BEADS_DIR": ocx.scratch_root + "/.beads",
    "BD_DISABLE_METRICS": "1",
    "BD_NON_INTERACTIVE": "1",
    "NO_COLOR": "1",
}

# ── Tier 1 + 2: liveness, version shape from structured output ─────────────
r = ocx.run(BD, "version", "--json", env = ENV)
expect.ok(r)
expect.matches(r.stdout, r"\"version\":\s*\"\d+\.\d+\.\d+\"")

# ── Tier 3: embedded-Dolt issue graph — dependency resolution ──────────────
# Create a blocker and a blocked issue, link them, and assert bd's computed
# views: `ready` holds only the blocker, `blocked` only the dependent. Ids are
# hash-generated under our prefix, so nothing here echoes the input.
def run(*args):
    res = ocx.run(BD, env = ENV, *args)
    expect.ok(res)
    return res.stdout

def check_issue_graph():
    # windows/arm64 is built CGO_ENABLED=0 upstream: no embedded Dolt, server
    # mode only — nothing hermetic to exercise beyond Tier 1/2 there.
    if ocx.target_platform.os == ocx.os.Windows and ocx.target_platform.arch == ocx.arch.Arm64:
        return
    run("init", "--prefix", "smk", "--skip-hooks", "--skip-agents", "--quiet")
    a = run("q", "Blocker").strip()
    b = run("q", "Blocked").strip()
    expect.matches(a, r"^smk-[0-9a-z]+$")
    expect.matches(b, r"^smk-[0-9a-z]+$")
    expect.ne(a, b)
    run("dep", "add", b, a)
    ready = run("ready", "--json")
    expect.contains(ready, "\"" + a + "\"")
    expect.false(("\"" + b + "\"") in ready, msg = "blocked issue listed as ready")
    blocked = run("blocked", "--json")
    expect.contains(blocked, "\"" + b + "\"")

check_issue_graph()
