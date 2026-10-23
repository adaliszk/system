---
description: Run a Google Dotprompt `.prompt` file for a fuzzy or judgement step (classify, extract, summarize, rate) via dotprompt-cli, defaulting to local ollama. Prefer this over inline prose generation.
name: dotprompt
---

# When

REACH for `dotprompt-cli` when a step needs MODEL JUDGEMENT rather than deterministic
logic: classify, extract structured fields, summarize, rate, or decide. KEEP that
judgement in a versioned `.prompt` file with a declared input/output contract, and
CALL it as a tool instead of spelling the reasoning out inline each time.

This is the probabilistic half of the toolkit; `skill-macros` (deterministic DSL
rendering) and `mdq` (structural Markdown extraction) are the deterministic halves.
A `.prompt` file carries its own model, config, and schema, so it runs self-contained.

# Execution

1. FEED input as a JSON object on stdin (merged into the template vars):
   ```sh
   echo '{"text": "..."}' | dotprompt-cli path/to/judge.prompt
   ```
   OR pass a JSON file with `--data vars.json`. Non-JSON stdin is `{{stdin}}`.
2. LET the `.prompt` file choose the model via its `model:` field. OVERRIDE only
   when deliberately escalating a tier:
   ```sh
   dotprompt-cli --model anthropic/claude-opus-4-8 path/to/judge.prompt
   ```
3. USE `--dry-run` to inspect the rendered request without calling a model, and
   `--metrics` for token/timing data on stderr.

# Model Routing

DEFAULT to local ollama; ESCALATE to an external provider only when the task
genuinely needs a higher tier. Selection order: `--model` flag → prompt `model:`
field → `default_model` from config.

Config lives at `~/.config/dotprompt-cli/config.yaml`. Point a `local` provider at
the ollama OpenAI-compatible endpoint:

```yaml
default_model: local/<ollama-model>
providers:
  local:
    api: chat_completions
    base_url: http://localhost:11434/v1
    api_key: unused
```

External providers read `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` from the environment.

# Prompt Shape

ONE `.prompt` = one typed job. DECLARE the input contract in frontmatter and the
output as a response schema (Picoschema), so the result comes back structured
rather than as free prose.

```handlebars
---
model: local/<ollama-model>
config:
  temperature: 0.1
input:
  schema:
    text: string
output:
  schema:
    label: string, one of: bug | feature | chore
    confidence: number
---
{{role "system"}}
You classify work items. Reply with the schema only.
{{role "user"}}
{{text}}
```
