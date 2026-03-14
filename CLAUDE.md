# lex-cognitive-weathering

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-cognitive-weathering`
- **Version**: 0.1.0
- **Namespace**: `Legion::Extensions::CognitiveWeathering`

## Purpose

Models long-term cumulative cognitive wear based on allostatic load theory. Stressors of different types and intensities erode cognitive integrity over time. Manageable stressors (intensity <= `TEMPERING_THRESHOLD`) also increase tempering level — a resilience multiplier. Overwhelming stressors erode without building resilience. Integrity is restored via `recover!` or `rest!`. Effective capacity is a function of both integrity and tempering level: `integrity * (1 + tempering * 0.2)`.

## Gem Info

- **Gemspec**: `lex-cognitive-weathering.gemspec`
- **Require**: `lex-cognitive-weathering`
- **Ruby**: >= 3.4
- **License**: MIT
- **Homepage**: https://github.com/LegionIO/lex-cognitive-weathering

## File Structure

```
lib/legion/extensions/cognitive_weathering/
  version.rb
  helpers/
    constants.rb          # Stressor types, wear/recovery rates, integrity/weathering label tables
    stressor.rb           # Stressor class — one cognitive stressor event
    weathering_engine.rb  # WeatheringEngine — integrity and tempering state machine
  runners/
    cognitive_weathering.rb  # Runner module — public API
  client.rb
```

## Key Constants

| Constant | Value | Meaning |
|---|---|---|
| `MAX_STRESSORS` | 200 | Ring buffer for stressor history |
| `MAX_EVENTS` | 500 | Ring buffer for event log |
| `DEFAULT_INTEGRITY` | 1.0 | Starting integrity level |
| `WEAR_RATE` | 0.02 | Multiplier: actual wear = `cumulative_impact * WEAR_RATE` |
| `RECOVERY_RATE` | 0.01 | Multiplier: actual recovery = `amount * RECOVERY_RATE` |
| `TEMPERING_RATE` | 0.03 | Multiplier: tempering gained = `cumulative_impact * TEMPERING_RATE` (manageable stressors only) |
| `TEMPERING_THRESHOLD` | 0.4 | Stressor intensity <= this = manageable (builds tempering) |
| `CRITICAL_INTEGRITY` | 0.3 | `fragile?` threshold |
| `BREAKDOWN_INTEGRITY` | 0.1 | `breaking?` threshold |

`STRESSOR_TYPES`: `[:cognitive_overload, :emotional_strain, :decision_fatigue, :conflict_exposure, :uncertainty, :time_pressure, :monotony, :complexity]`

Integrity labels: `0.8..1.0` = `'pristine'`, `0.6..0.8` = `'strong'`, `0.4..0.6` = `'worn'`, `0.2..0.4` = `'fragile'`, `0.0..0.2` = `'breaking'`

Weathering labels (by tempering level): `0.7..1.0` = `'tempered'`, `0.5..0.7` = `'resilient'`, `0.3..0.5` = `'stable'`, `0.1..0.3` = `'weathered'`, `0.0..0.1` = `'eroded'`

## Key Classes

### `Helpers::Stressor`

One cognitive stressor event.

- `cumulative_impact` — `(intensity * (duration / 3600.0)).clamp(0.0, 1.0)` — intensity scaled by hours of exposure
- `manageable?` — intensity <= `TEMPERING_THRESHOLD` (0.4); manageable stressors build tempering
- `overwhelming?` — intensity >= 0.8
- Invalid stressor types silently default to `:cognitive_overload`
- Fields: `id` (UUID), `description`, `stressor_type`, `intensity`, `duration` (seconds), `domain`, `recorded_at`

### `Helpers::WeatheringEngine`

Integrity and tempering state machine.

- `apply_stressor(stressor)` — appends to history; calls `wear!(cumulative_impact)` for all stressors; additionally calls `temper!(cumulative_impact * TEMPERING_RATE)` for manageable stressors only; returns `to_h`
- `recover!(amount)` — delta = `min(amount * RECOVERY_RATE, 1.0 - integrity)`; small incremental restoration
- `rest!(amount)` — delta = `min(amount * RECOVERY_RATE * 5.0, 1.0 - integrity)`; 5x faster than `recover!`
- `effective_capacity` — `(integrity * (1.0 + tempering_level * 0.2)).clamp(0.0, 1.2)` — tempered agents can exceed 1.0 base capacity
- `fragile?` — integrity <= 0.3; `breaking?` — integrity <= 0.1
- `weathering_report` — full status including integrity, integrity_label, tempering_level, weathering_label, effective_capacity, total_wear, total_recovery, stressor_count, fragile, breaking, recent_stressors (last 5)
- `prune_stressors` (private) — shifts oldest when at `MAX_STRESSORS`
- `prune_events` (private) — shifts oldest when at `MAX_EVENTS`

## Runners

Module: `Legion::Extensions::CognitiveWeathering::Runners::CognitiveWeathering`

| Runner | Key Args | Returns |
|---|---|---|
| `apply_stressor` | `description:`, `stressor_type:`, `intensity:`, `duration:`, `domain:` | engine `to_h` merged with `stressor:` hash |
| `recover` | `amount:` | engine `to_h` (integrity, tempering_level, effective_capacity, fragile, breaking) |
| `rest` | `amount:` | engine `to_h` |
| `weathering_report` | — | full weathering report hash |
| `integrity_status` | — | `{ integrity:, integrity_label:, tempering_level:, weathering_label:, effective_capacity:, fragile:, breaking: }` |

No `engine:` injection keyword. Engine is a private memoized `@weathering_engine`.

## Integration Points

- No actors defined; `apply_stressor` should be called when sustained demands are applied to the cognitive system
- `effective_capacity` can gate new commitments — when below a threshold, refuse additional load
- `fragile?` / `breaking?` can trigger `lex-consent` escalation or `lex-extinction` containment review
- Pairs with `lex-cognitive-surplus` (acute capacity) — weathering tracks long-term erosion while surplus tracks real-time allocation
- All state is in-memory per `WeatheringEngine` instance

## Development Notes

- Wear and recovery use very small multipliers — `WEAR_RATE = 0.02` means a stressor with `cumulative_impact = 1.0` only drains 0.02 integrity. This is intentional for gradual erosion
- `rest!` is 5x faster than `recover!` — both work by multiplying `amount` by their respective rates (not setting directly)
- `effective_capacity` can exceed 1.0 (up to 1.2) for highly tempered agents
- Integrity and weathering labels are **strings**, not symbols
- Invalid stressor types default to `:cognitive_overload` silently (no exception)
- `apply_stressor` returns the engine's compact `to_h` (5 fields) plus the stressor hash — not the full `weathering_report`
