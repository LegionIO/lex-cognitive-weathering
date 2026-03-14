# lex-cognitive-weathering

LEX extension for LegionIO that models long-term cognitive wear from sustained workloads. Based on allostatic load theory: agents can be worn down by constant demands but also tempered (strengthened) by manageable challenges.

## Concept

Unlike acute fatigue (which recovers quickly), weathering represents cumulative stress that permanently reduces capacity unless actively restored. Manageable stressors build resilience (tempering). Overwhelming stressors erode integrity.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-cognitive-weathering'
```

## Usage

```ruby
client = Legion::Extensions::CognitiveWeathering::Client.new

# Apply a stressor
client.apply_stressor(
  description:   'Sprint deadline pressure',
  stressor_type: :time_pressure,
  intensity:     0.8,
  duration:      7200,
  domain:        'engineering'
)

# Apply a manageable challenge (builds tempering)
client.apply_stressor(
  description:   'Steady background complexity',
  stressor_type: :complexity,
  intensity:     0.3,
  duration:      3600
)

# Check current state
status = client.integrity_status
# => { integrity: 0.98, integrity_label: "pristine", tempering_level: 0.001, ... }

# Recover from wear
client.recover(amount: 1.0)

# Full rest (5x recovery rate)
client.rest(amount: 1.0)

# Full report
client.weathering_report
```

## Stressor Types

`:cognitive_overload`, `:emotional_strain`, `:decision_fatigue`, `:conflict_exposure`, `:uncertainty`, `:time_pressure`, `:monotony`, `:complexity`

## Integrity Labels

| Range     | Label    |
|-----------|----------|
| 0.8–1.0   | pristine |
| 0.6–0.8   | strong   |
| 0.4–0.6   | worn     |
| 0.2–0.4   | fragile  |
| 0.0–0.2   | breaking |

## Weathering Labels (Tempering Level)

| Range     | Label     |
|-----------|-----------|
| 0.7–1.0   | tempered  |
| 0.5–0.7   | resilient |
| 0.3–0.5   | stable    |
| 0.1–0.3   | weathered |
| 0.0–0.1   | eroded    |

## License

MIT
