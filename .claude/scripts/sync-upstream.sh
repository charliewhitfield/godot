#!/usr/bin/env bash
# Sync the `claude` branch with upstream/master HEAD. Idempotent.
# Run by Windows Task Scheduler daily; can also be invoked manually.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_DIR="$REPO_ROOT/.claude/logs"
STATE_DIR="$REPO_ROOT/.claude/state"
LOG_FILE="$LOG_DIR/sync-upstream.log"
STATUS_FILE="$STATE_DIR/sync-status.json"

mkdir -p "$LOG_DIR" "$STATE_DIR"

log() {
    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$ts] $*" >> "$LOG_FILE"
}

set_status() {
    local outcome="$1"
    local details="${2:-}"
    local ts
    ts=$(date -Iseconds)
    # Minimal escape: quotes/backslashes in details. Our messages don't contain them today.
    details=${details//\\/\\\\}
    details=${details//\"/\\\"}
    cat > "$STATUS_FILE" <<EOF
{
    "timestamp": "$ts",
    "outcome": "$outcome",
    "details": "$details"
}
EOF
}

fail() {
    log "ERROR: $1"
    set_status 'failed' "$1"
    exit 1
}

log "=== sync-upstream start ==="
cd "$REPO_ROOT" || fail "Could not cd to $REPO_ROOT"

[[ -d .git ]] || fail "Not a git repo: $REPO_ROOT"

branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" != "claude" ]]; then
    log "Skipping: current branch is '$branch', not 'claude'."
    set_status 'skipped' "Not on claude branch (current: $branch)"
    exit 0
fi

if [[ -n "$(git status --porcelain)" ]]; then
    log "Skipping: working tree not clean."
    set_status 'skipped' "Working tree dirty"
    exit 0
fi

# Bootstrap: add `upstream` remote on a fresh clone of the fork (where it'd be missing by default)
if ! git remote get-url upstream >/dev/null 2>&1; then
    log "Adding upstream remote (https://github.com/godotengine/godot.git)..."
    if ! git remote add upstream https://github.com/godotengine/godot.git; then
        fail "Failed to add upstream remote"
    fi
fi

log "Fetching upstream..."
if ! git fetch upstream --tags --prune >> "$LOG_FILE" 2>&1; then
    fail "git fetch upstream failed"
fi

upstream_sha=$(git rev-parse upstream/master)
head=$(git rev-parse HEAD)

if git merge-base --is-ancestor "$upstream_sha" HEAD 2>/dev/null; then
    log "upstream/master ($upstream_sha) already in HEAD ($head). No-op."
    set_status 'up-to-date' "upstream/master at $upstream_sha"
    log "=== sync-upstream done ==="
    exit 0
fi

# Determine upstream version (best-effort) for nicer commit message
version_label=""
if ver=$(git show 'upstream/master:version.py' 2>/dev/null); then
    maj=$(echo "$ver" | grep -oP 'major\s*=\s*\K\d+' || true)
    min=$(echo "$ver" | grep -oP 'minor\s*=\s*\K\d+' || true)
    pat=$(echo "$ver" | grep -oP 'patch\s*=\s*\K\d+' || true)
    stat=$(echo "$ver" | grep -oP 'status\s*=\s*"\K[^"]+' || true)
    if [[ -n "$maj" && -n "$min" && -n "$stat" ]]; then
        if [[ "${pat:-0}" != "0" ]]; then
            version_label="$maj.$min.$pat-$stat"
        else
            version_label="$maj.$min-$stat"
        fi
    fi
fi

if [[ -n "$version_label" ]]; then
    subject="Merge upstream master into claude ($version_label)"
else
    subject="Merge upstream master into claude"
fi
merge_msg=$(printf '%s\n\nupstream/master at %s' "$subject" "$upstream_sha")

log "Merging upstream/master ($upstream_sha); upstream version: $version_label"
if ! git merge upstream/master -m "$merge_msg" >> "$LOG_FILE" 2>&1; then
    git merge --abort 2>/dev/null || true
    fail "Merge conflict between claude and upstream/master ($upstream_sha). Aborted; manual resolution needed."
fi

log "Pushing origin/claude..."
if ! git push origin claude >> "$LOG_FILE" 2>&1; then
    fail "Push to origin/claude failed."
fi

new_head=$(git rev-parse HEAD)
log "Synced. claude HEAD now $new_head. Upstream version: $version_label"
set_status 'updated' "Merged upstream/master ($upstream_sha). Upstream version: $version_label"
log "=== sync-upstream done ==="
exit 0
