# Godot docs index — curated links

URL convention: `https://docs.godotengine.org/en/stable/…`. `/stable/` tracks the latest released 4.x and is the most stable URL form.
If a 4.7-only feature isn't in `/stable/`, fall back to the GitHub source under [doc/classes/](../doc/classes/) on this checkout.

## Entry points

- [All classes index](https://docs.godotengine.org/en/stable/classes/index.html) — top of the class reference; first stop for any API lookup.
- [GDScript section index](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html) — landing page for all GDScript language docs.
- [Manual home](https://docs.godotengine.org/en/stable/index.html) — full doc home; use when the topic doesn't fit a known section.

## GDScript language

- [GDScript basics](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) — syntax, types, control flow, classes; default starter reference.
- [Static typing in GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html) — type hints, inferred types, when typing affects perf.
- [GDScript exports (`@export`)](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — annotation reference for all `@export_*` variants.
- [@GDScript annotations](https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html) — canonical reference for `@abstract`, `@onready`, `@tool`, `@warning_ignore`, etc.
- [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) — official conventions; consult alongside the user's preferences.
- [GDScript warning system](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/warning_system.html) — what each warning means and how to suppress.
- [GDScript documentation comments](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html) — `##` comment format the editor surfaces.

## Performance & optimization

- [Performance section index](https://docs.godotengine.org/en/stable/tutorials/performance/index.html) — landing page for all perf topics.
- [General optimization tips](https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html) — engine-wide perf guidance.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — `Thread`, `Mutex`, `Semaphore` API.
- [Thread-safe APIs](https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html) — what is and isn't safe to call off the main thread.
- [Using servers directly](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html) — bypassing the scene tree for raw server calls.

## Type system & values

- [Variant class](https://docs.godotengine.org/en/stable/classes/class_variant.html) — unified value type; conversions, equality, hashing.
- [Array class](https://docs.godotengine.org/en/stable/classes/class_array.html) — typed and untyped array reference.
- [Dictionary class](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) — typed dictionary support and ordering semantics.

## Core API hotspots (classref)

- [Object](https://docs.godotengine.org/en/stable/classes/class_object.html) — base class; signals, metadata, dynamic properties.
- [RefCounted](https://docs.godotengine.org/en/stable/classes/class_refcounted.html) — reference-counted Object; default GDScript class base.
- [Node](https://docs.godotengine.org/en/stable/classes/class_node.html) — scene tree base class; `_ready`, `_process`, groups.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — disk-serializable RefCounted.
- [Signal](https://docs.godotengine.org/en/stable/classes/class_signal.html) — signal value type; `connect`, `emit`, `disconnect`.
- [Callable](https://docs.godotengine.org/en/stable/classes/class_callable.html) — bound function reference; `bind`, `call`, `call_deferred`.
- [PackedByteArray](https://docs.godotengine.org/en/stable/classes/class_packedbytearray.html) — typed contiguous arrays; prefer `Packed*Array` over `Array` for primitives.

## Scene & nodes

- [Scene tree (manual)](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html) — how the tree, viewports, and `SceneTree` relate.
- [Nodes and scene instances](https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html) — instancing, packing, `PackedScene`.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — `add_to_group`, `get_tree().get_nodes_in_group(...)`.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — autoload setup and access patterns.

## Editor & tooling

- [Debugger panel](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/index.html) — in-editor debugger features and profiler entry.

## 3D rendering

- [Visibility ranges (HLOD)](https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html) — per-mesh distance culling on `GeometryInstance3D` plus `Node3D.visibility_parent` chains.

## Shaders & rendering

- [Godot Shading Language reference](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html) — high-level shader language; uniform types, built-ins, no SSBO/imageStore.
- [Compositor class](https://docs.godotengine.org/en/stable/classes/class_compositor.html) — viewport-level resource holding an array of CompositorEffects (experimental).
- [CompositorEffect class](https://docs.godotengine.org/en/stable/classes/class_compositoreffect.html) — `_render_callback` hook for custom RenderingDevice passes inside the rendering pipeline.
- [RenderingDevice class](https://docs.godotengine.org/en/stable/classes/class_renderingdevice.html) — low-level GPU API; storage buffers, GLSL compute, `buffer_get_data` / `buffer_get_data_async` for GPU→CPU readback.

## Migration / version notes

- [Migrating to a new Godot version](https://docs.godotengine.org/en/stable/tutorials/migrating/index.html) — migration index; check when bumping minor versions.

---

When adding a link: place under the closest matching section; if none fits, add a new `## Section` header. Note in 8–15 words why it's worth keeping.
