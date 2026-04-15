# Flappy Bird

[![Status](https://img.shields.io/badge/status-phase%200%20of%206-yellow)](#roadmap)
[![Godot](https://img.shields.io/badge/Godot-4.x-478CBF?logo=godotengine&logoColor=white)](https://godotengine.org/)
[![License](https://img.shields.io/github/license/0xRnato/flappy-bird)](LICENSE)

**A one-button side-scroller built in Godot 4 — flap through an endless pipe field, one tap at a time.**

A faithful Flappy Bird clone written in GDScript. Keeps the brutal one-pipe-at-a-time
difficulty of the original, adds a bit of modern juice (screen shake, flap
animation, parallax background), persists a local high score, and ships as an
HTML5 build playable in the browser.

## Status

**Phase 0 of 6 — foundation.** The repository scaffold is in place:

- ✅ Godot 4 project structure, version-controlled `.gitignore` and `.gitattributes`
- ✅ Kenney CC0 sprites, fonts and SFX imported
- ✅ Design doc ([`DESIGN.md`](DESIGN.md)) with pillars, mechanics and tuning values
- ✅ MIT license, Conventional-Commits policy

Coming next: the core loop — bird physics, pipe spawner, collision detection,
game-over and restart. See the [roadmap](#roadmap).

## Why Flappy Bird

Flappy Bird is the smallest complete video game possible: one input, one
obstacle type, no AI, no level design, no save slots beyond a single integer.
That makes it the perfect first Godot project — every subsystem a real game
needs (physics, collision shapes, scene composition, signals, autoloads,
persistence, audio, UI states, web export) has to be touched, but none of
them can sprawl. The scope is locked by the genre itself, which means the
project either ships polished or it doesn't ship.

That constraint is the whole point. This repo is a deliberate exercise: pick
a known-good design, execute it cleanly end to end, and ship a playable build
a recruiter can click through in ten seconds.

## Tech stack

| Layer           | Tool                                           |
|-----------------|------------------------------------------------|
| Engine          | Godot 4.x                                      |
| Language        | GDScript                                       |
| Art             | [Kenney](https://kenney.nl/assets) CC0 sprites |
| Fonts           | Press Start 2P (OFL) / Kenney Pixel (CC0)      |
| Audio           | Kenney UI + Impact SFX (CC0)                   |
| Persistence     | `ConfigFile` in `user://score.cfg`             |
| Export target   | HTML5 (WebAssembly) on GitHub Pages            |
| CI              | GitHub Actions — auto-export and deploy        |

## Project structure

```
flappy-bird/
├── .github/workflows/   # HTML5 export + Pages deploy (Phase 4)
├── assets/
│   ├── sprites/         # Kenney pack
│   ├── sfx/
│   └── fonts/
├── scenes/
│   ├── main.tscn
│   ├── bird.tscn
│   ├── pipe.tscn
│   ├── pipe_spawner.tscn
│   └── ui/              # main menu, HUD, game over
├── scripts/
│   ├── bird.gd
│   ├── pipe.gd
│   ├── pipe_spawner.gd
│   ├── game_manager.gd
│   └── score_store.gd
├── DESIGN.md            # game design document
├── LICENSE
├── README.md
├── icon.svg
└── project.godot
```

## Development

### Requirements

- [Godot 4.x](https://godotengine.org/download) (standard build, not .NET)
- Git

### Setup

```bash
git clone git@github.com:0xRnato/flappy-bird.git
cd flappy-bird
```

Open `project.godot` in the Godot editor. The first import takes a few
seconds while Godot generates `.godot/` metadata (gitignored).

### Run

- Press `F5` in the editor to run the main scene.
- Controls: `Space` / `Click` / `Touch` to flap. `Enter` to start / restart.
  `Esc` to pause.

### Export (HTML5)

Once Phase 4 lands, a GitHub Actions workflow builds an HTML5 export on every
push to `main` and publishes it to GitHub Pages. For manual exports:

- `Project → Export…` in the editor, pick the HTML5 preset, export to `build/web/`.
- Serve locally with `python -m http.server 8000 -d build/web` and open
  `http://localhost:8000`.

## Roadmap

| Phase | Focus                                                                       |
|-------|-----------------------------------------------------------------------------|
| 0     | Foundation: project scaffold, assets, design doc, license (current)         |
| 1     | Core loop: bird physics, pipe spawner, collision-based game over, restart   |
| 2     | Score and persistence: pass-through score counter, high score via `ConfigFile` |
| 3     | Polish: SFX, flap animation, particles, screen shake, parallax BG, menus    |
| 4     | Web export: HTML5 build, GitHub Actions, Pages deploy                       |
| 5     | Portfolio pass: gameplay GIF, screenshots, design-decisions writeup         |

## Design decisions

- **GDScript over C#.** Zero build step, one-file scripts, tight editor
  integration. A one-button game does not exercise anything C# would win at.
- **Kenney CC0 art, not custom pixel art.** Time spent in Aseprite is time
  not spent shipping. The pack is tasteful, consistent, and license-clean.
- **Endless runner, no levels.** Matches the original. Eliminates a whole
  class of scope creep (level editor, progression, save slots).
- **`user://` high score, not cloud.** No backend means no auth, no
  accounts, no hosting cost. `ConfigFile` is two lines of GDScript and
  round-trips perfectly across sessions.
- **HTML5 export, not desktop binaries.** A playable demo one click away
  beats a `.exe` nobody downloads. GitHub Pages is free and fast enough
  for a 5 MB WASM build.
- **Physics via `CharacterBody2D`, not `RigidBody2D`.** Deterministic,
  trivial to tune, and avoids the floatiness that rigid-body gravity
  introduces at low mass.

## License

[MIT](LICENSE).
