# lex-cognitive-weathering

A LegionIO cognitive architecture extension that models long-term cumulative cognitive wear. Based on allostatic load theory: sustained demands erode integrity, but manageable challenges also build tempering — a resilience multiplier that allows tempered agents to exceed their baseline capacity.

## What It Does

Tracks cognitive **integrity** (0.0–1.0) and **tempering level** (0.0–1.0) through stressor events and recovery.

Each stressor has:
- A type (`:cognitive_overload`, `:emotional_strain`, `:decision_fatigue`, `:conflict_exposure`, `:uncertainty`, `:time_pressure`, `:monotony`, `:complexity`)
- Intensity (0.0–1.0) and duration (seconds)
- `cumulative_impact` = `intensity * (duration / 3600.0)`

Stressors with intensity <= 0.4 are **manageable** — they wear down integrity *and* build tempering. Overwhelming stressors (intensity >= 0.8) erode without building resilience.

**Effective capacity** = `integrity * (1 + tempering * 0.2)` — a tempered agent can exceed 1.0 base capacity (up to 1.2).

## Usage

```ruby
require 'lex-cognitive-weathering'

client = Legion::Extensions::CognitiveWeathering::Client.new

# Apply an overwhelming stressor (erodes integrity, no tempering)
client.apply_stressor(
  description:   'Sprint deadline pressure',
  stressor_type: :time_pressure,
  intensity:     0.8,
  duration:      7200,
  domain:        'engineering'
)
# => { integrity: 0.9984, tempering_level: 0.0, effective_capacity: 0.9984, fragile: false, ... }

# Apply a manageable stressor (erodes slightly, builds tempering)
client.apply_stressor(
  description:   'Steady background complexity',
  stressor_type: :complexity,
  intensity:     0.3,
  duration:      3600
)
# => { integrity: 0.9980, tempering_level: 0.0009, effective_capacity: 0.9982, ... }

# Check current state
client.integrity_status
# => { integrity: 0.9980, integrity_label: "pristine", tempering_level: 0.0009, weathering_label: "eroded", ... }

# Recover from wear (small increment)
client.recover(amount: 1.0)
# => { integrity: 0.9990, ... }

# Full rest (5x recovery rate)
client.rest(amount: 1.0)
# => { integrity: 0.9995, ... }

# Full weathering report
client.weathering_report
# => { integrity: 0.9995, integrity_label: "pristine", tempering_level: 0.0009, weathering_label: "eroded",
#      effective_capacity: 0.9997, total_wear: 0.0021, total_recovery: 0.0015,
#      stressor_count: 2, fragile: false, breaking: false, recent_stressors: [...] }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
