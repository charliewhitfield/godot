# CLAUDE.md — `claude` branch (personal Godot Engine fork)

## Branch purpose

Personal research workspace on a fork of `godotengine/godot`. The user's actual Godot/GDScript projects live in separate repos. On this branch, help the user answer GDScript usage and optimization questions for those external projects — primarily by citing the official docs, occasionally by digging into the C++ source for ground truth.

No engine source edits are expected. The files added by this CLAUDE.md and under `.claude/` are personal-branch infrastructure only.

## Read this first

- [.claude/docs-index.md](.claude/docs-index.md) — curated docs URLs, organized by topic. Check here before searching the web.
- The loaded `godot` skill covers editor cache, GDScript style, and ivoyager-ecosystem conventions. **Do not duplicate** that material here.
- The user's global `~/.claude/CLAUDE.md` covers language-agnostic style preferences. Defer to it.

## Doc-vs-source decision rule

**Default:** cite docs.godotengine.org. Quote the load-bearing sentence and include the URL.

**Dig into C++ source when:**
- Docs are silent, ambiguous, or contradict observed behavior.
- The user explicitly asks "how does X actually work" or "what's it doing under the hood."
- The question is performance-sensitive and hinges on implementation detail (dictionary growth, signal dispatch cost, Variant copy semantics, container reallocation, etc.).
- Behavior depends on a 4.x detail not yet in `/stable/` docs.

**Citation form for source:** `path/file.cpp:LINE` relative to repo root, name the function, quote ≤5 lines if load-bearing. Use the markdown link form so the user can click through.

**Combine when both apply:** lead with the doc citation, then follow with "Source confirms ([file.cpp:line](file.cpp:line)): …".

## Source map (GDScript-optimization queries)

Don't re-explore — these are already mapped. If a question pulls in unmapped territory, reach further and append the new path here.

- **GDScript pipeline:** [modules/gdscript/gdscript_tokenizer.cpp](modules/gdscript/gdscript_tokenizer.cpp), [_parser.cpp](modules/gdscript/gdscript_parser.cpp), [_analyzer.cpp](modules/gdscript/gdscript_analyzer.cpp), [_compiler.cpp](modules/gdscript/gdscript_compiler.cpp), [_byte_codegen.cpp](modules/gdscript/gdscript_byte_codegen.cpp), [_vm.cpp](modules/gdscript/gdscript_vm.cpp)
- **GDScript runtime:** [modules/gdscript/gdscript_function.cpp](modules/gdscript/gdscript_function.cpp), [gdscript_cache.cpp](modules/gdscript/gdscript_cache.cpp), [gdscript_utility_functions.cpp](modules/gdscript/gdscript_utility_functions.cpp)
- **Variant system:** [core/variant/](core/variant/)
- **Object / signals / properties / script-language binding:** [core/object/object.cpp](core/object/object.cpp), [class_db.cpp](core/object/class_db.cpp), [script_language.cpp](core/object/script_language.cpp)
- **Containers (perf-relevant):** [core/templates/hash_map.h](core/templates/hash_map.h), [a_hash_map.h](core/templates/a_hash_map.h), [local_vector.h](core/templates/local_vector.h), [cowdata.h](core/templates/cowdata.h), [hash_set.h](core/templates/hash_set.h), [fixed_vector.h](core/templates/fixed_vector.h)
- **Resources:** [core/io/resource.cpp](core/io/resource.cpp), [scene/resources/](scene/resources/)
- **Scene tree / nodes:** [scene/main/node.cpp](scene/main/node.cpp), [scene_tree.cpp](scene/main/scene_tree.cpp), [viewport.cpp](scene/main/viewport.cpp)
- **Servers:** [servers/rendering/](servers/rendering/), [servers/physics_2d/](servers/physics_2d/), [servers/physics_3d/](servers/physics_3d/), [servers/audio/](servers/audio/)
- **Class XML reference (source for the docs site):** [doc/classes/](doc/classes/) plus per-module [modules/*/doc_classes/](modules/) trees.

## Workflow micro-rules

- Update [.claude/docs-index.md](.claude/docs-index.md) whenever you find a URL the user will likely re-need. One canonical link per concept; don't accumulate near-duplicates.
- Cite both file paths and line numbers using the markdown link form so the user can click through.
- **Remote layout:** `origin` is the user's fork (`charliewhitfield/godot`); `upstream` is `godotengine/godot` (read-only). The `claude` branch tracks `origin/claude`. Standard fork-and-PR convention.
- **Git authorization on this branch:** full git operations on `claude` are pre-authorized — commit and push to `origin` without asking each time. Never push to `upstream`. Never PR against `upstream`. Never `git add` engine source files unless explicitly asked.

## Auto-sync with upstream

A Windows scheduled task runs [.claude/scripts/sync-upstream.sh](.claude/scripts/sync-upstream.sh) daily via Git Bash. It fetches `upstream/master` and, if there are new commits, merges into `claude` and pushes to `origin/claude`. The script auto-adds the `upstream` remote on a fresh clone where it'd be missing. Strategy is rolling-master rather than tag-anchored — upstream only git-tags `*-stable` releases, so beta/dev cadence (every ~2 weeks) is only visible via master HEAD.

Outcomes (written to [.claude/state/sync-status.json](.claude/state/sync-status.json), gitignored):

- `up-to-date` — `upstream/master` already in HEAD; no-op.
- `updated` — merged + pushed successfully.
- `skipped` — wrong branch or working tree dirty; retried next run.
- `failed` — fetch/merge/push error; needs manual resolution.

**Session-start check:** on first interaction with this repo, if `.claude/state/sync-status.json` exists and `outcome == "failed"`, proactively surface the failure (with `details`) to the user. Otherwise stay silent.

**Manual run (from Git Bash):** `bash .claude/scripts/sync-upstream.sh`

**Logs:** `.claude/logs/sync-upstream.log` (gitignored, append-only).
