# Flappy Bird — Game Design Document

Concise GDD for a faithful Flappy Bird clone in Godot 4. Covers pillars,
core loop, mechanics, tuning values, scene graph, input, audio, UI
states and persistence. Everything here should fit one read-through.

## Pillars

1. **One input.** A single tap is the entire verb set. No combos, no
   dashes, no weapons.
2. **Punishing but fair.** One hit equals game over. The player reads
   the pipe gap and commits; there is no second chance.
3. **Bite-sized.** Sessions last 10 seconds on average. The loss-to-retry
   path is a single keypress — friction is death.
4. **Juicy.** The original is dry; the clone is not. Flap animation,
   particle trail, screen shake on hit, crisp SFX.

## Core loop

```
Menu
  ↓ (Enter / tap)
Playing ──────────────→ Game Over
  │  flap → rise                │
  │  gravity → fall             │  (collision OR floor OR ceiling)
  │  pass pipe → score +1       │
  └──────────────────────────────┘
                                  ↓ (Enter / tap)
                                 Playing (restart)
```

## Mechanics

All values are starting points; Phase 3 does a tuning pass.

| Parameter              | Value          | Notes                                     |
|------------------------|----------------|-------------------------------------------|
| Gravity                | `1800 px/s²`   | Downward constant                         |
| Flap impulse           | `-450 px/s`    | Sets `velocity.y` (not additive)          |
| Terminal fall velocity | `+1000 px/s`   | Clamped                                   |
| Pipe scroll speed      | `200 px/s`     | Constant; no speed ramp (original parity) |
| Pipe gap size          | `150 px`       | Vertical free space between top/bottom    |
| Pipe spawn interval    | `1.5 s`        | Fixed                                     |
| Pipe gap Y range       | `120–520 px`   | Random per spawn, keeps gap reachable     |
| Bird rotation          | `-25°…+70°`    | Interpolated from velocity.y              |
| Game-over freeze       | `400 ms`       | Hitstop before showing the overlay        |
| Screen shake on hit    | `6 px / 250 ms`| Decaying                                  |

## Scene graph

```
Main (Node2D)
├── Background (ParallaxBackground)
│   ├── Sky (ParallaxLayer)
│   └── Ground (ParallaxLayer)
├── PipeSpawner (Node2D, script)
│   └── [dynamically spawned Pipe instances]
├── Bird (CharacterBody2D, script)
│   ├── AnimatedSprite2D
│   ├── CollisionShape2D (capsule)
│   └── FlapSFX / HitSFX (AudioStreamPlayer)
├── HUD (CanvasLayer)
│   ├── ScoreLabel
│   └── HighScoreLabel
└── UIRoot (CanvasLayer)
    ├── MainMenu
    ├── PauseOverlay
    └── GameOverOverlay

Pipe (Node2D)
├── TopPipeSprite + TopCollisionShape
├── BottomPipeSprite + BottomCollisionShape
└── ScoreTrigger (Area2D, one-shot, emits scored on body_entered)
```

`GameManager` (autoload singleton) owns game state (`MENU`, `PLAYING`,
`GAME_OVER`, `PAUSED`), emits `state_changed`, and coordinates restarts.

`ScoreStore` (autoload singleton) reads and writes high score to
`user://score.cfg` via `ConfigFile`. Exposes `current`, `best`, `record(score)`.

## Input map

| Action        | Keyboard     | Mouse / Touch      |
|---------------|--------------|--------------------|
| `flap`        | Space        | Left click / touch |
| `start`       | Enter        | Left click / touch |
| `pause`       | Esc / P      | —                  |
| `debug_reset` | F8 (editor)  | —                  |

All actions are defined in `project.godot` under
`[input]` so rebinding stays in one place.

## UI states

- **Main menu** — Title, best score, "Press Enter to flap", faint background parallax, no bird.
- **Playing** — Bird active, HUD visible (score top-left, best top-right), parallax scrolling.
- **Paused** — Dim overlay, "Paused — Esc to resume", gameplay frozen via `get_tree().paused = true`.
- **Game over** — Freeze frame, shake, "Game Over" overlay with final score, best score, and "Press Enter to retry".

Transitions are gated by `GameManager.state`; UI nodes listen to
`state_changed` and toggle their own visibility. No explicit scene
swaps — a single `main.tscn` hosts every state.

## Audio

| Event             | SFX                                   |
|-------------------|---------------------------------------|
| Flap              | Short, high-pitched blip              |
| Score (pass pipe) | Light coin-style chime                |
| Hit               | Thud + brief low-frequency rumble     |
| Menu confirm      | Soft UI click                         |

Sources: Kenney UI Audio and Impact Sounds packs (CC0). If the free
packs do not produce a satisfying flap, a custom one is generated via
[sfxr](https://sfxr.me/) — still license-clean, still zero cost.

## Persistence

High score only. Stored in `user://score.cfg` via Godot's built-in
`ConfigFile`:

```ini
[score]
best = 42
```

`user://` resolves to `%APPDATA%\Godot\app_userdata\Flappy Bird` on
Windows. No cloud sync, no accounts, no telemetry. The file is safe to
delete; the game will recreate it with `best = 0`.

## Art direction

- **Style.** Kenney's flat-cartoon pack — clean vector-like sprites, no
  outlines, mid-saturation palette.
- **Palette.** Teal sky, ochre ground, leaf-green pipes, yellow bird.
  Controlled by the pack — no custom recolours.
- **Resolution.** 1080×1920 base (portrait), stretch mode
  `canvas_items` with `keep` aspect so mobile browsers render cleanly.
- **Parallax.** Two layers behind gameplay: sky (`motion_scale.x = 0.2`)
  and ground strip (`motion_scale.x = 1.0`, matched to pipe scroll).

## Out of scope

- Multiple bird skins, unlockable characters.
- Power-ups, shields, double-jumps, gravity flips.
- Day/night cycle, weather, background variety beyond one layer.
- Online leaderboard, social sharing, auth.
- Mobile app store export (Android/iOS) — HTML5 + touch input covers
  mobile browsers adequately.

## Risks

- **Input latency on HTML5.** Godot's web export adds ~16 ms over
  desktop. Tuning (Phase 3) is done against the HTML5 build, not the
  editor, to avoid shipping a game that feels floaty in the browser.
- **Audio on mobile Safari.** iOS blocks autoplay; the first sound has
  to be user-gated. The main menu's "press to start" handles this
  naturally — flap SFX is always second at minimum.
- **Pipe spawning determinism.** `randi()` seeded per session is fine
  for a flappy clone; nothing in the design benefits from determinism,
  so the seed is intentionally not fixed.
