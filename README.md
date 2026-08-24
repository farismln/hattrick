# Hattrick

Hattrick is a small collection of reusable [Codex skills](https://learn.chatgpt.com/docs/build-skills) for security-audit planning and goal definition. It currently includes:

| Skill | Purpose |
| --- | --- |
| `create-threat-model` | Turns completed audit context into an evidence-bound `threat-model.md`, including assets, invariants, actors, trust boundaries, lifecycle models, and testable threat hypotheses. It does not hunt for or report vulnerabilities. |
| `goal-prompt` | Rewrites an objective and its available context as a precise, copy-paste-ready Codex goal prompt with explicit acceptance, evidence, scope, and completion conditions, and instructs the pursuing goal to append plausible off-goal findings to a single `leads/ledger.md` markdown ledger (issue, evidence state, blocker) instead of losing or derailing on them. It does not execute or register the resulting goal. |

Each skill is stored in its own directory as a `SKILL.md` file. The installer makes the skills available to Codex by symlinking those directories into the Codex skills directory, so changes made in this checkout are reflected without reinstalling.

## Requirements

- Codex CLI, the Codex IDE extension, or the ChatGPT desktop app with standalone skill support
- Bash on Linux or another Unix-like environment
- A local checkout of this repository

## Installation

From the repository root, install every included skill:

```bash
./install.sh
```

By default, the installer links skills into `$CODEX_HOME/skills` when `CODEX_HOME` is set, or `~/.codex/skills` otherwise. Skills become available in new Codex turns.

To install only selected skills, pass their directory names:

```bash
./install.sh goal-prompt
./install.sh create-threat-model goal-prompt
```

To use a different skills directory, pass `--target`:

```bash
./install.sh --target /path/to/codex/skills
```

The installer is idempotent when a skill is already linked to this checkout. For safety, it refuses to replace an existing file, directory, or symlink that points somewhere else; move or remove that conflicting destination yourself before retrying.

Run `./install.sh --help` to see all installer options.

## Usage

Start a new Codex turn and invoke a skill by name with `$skill-name`. In Codex CLI or the IDE extension, you can also run `/skills` to browse installed skills.

### Create a threat model

Use this after audit scope, architecture, deployment facts, invariants, and other context have already been collected:

```text
Use $create-threat-model to turn the completed audit context in this workspace into an evidence-bound threat model.
```

You can also identify the input artifacts and output location explicitly:

```text
Use $create-threat-model with audit/scope-facts.md and audit/context-map.md, and write the result to audit/threat-model.md.
```

The skill keeps suspected threats as hypotheses and records the proof needed to validate them. Vulnerability hunting, exploit testing, severity assignment, and finding writeups remain separate follow-up work.

### Create a goal prompt

Give Codex the objective plus any relevant repository or threat-model context:

```text
Use $goal-prompt to turn this objective into a precise persistent Codex goal: find one novel, high-impact vulnerability in the in-scope contracts and provide a reproducible proof.
```

The response is a self-contained goal prompt of at most two paragraphs. Copy it into a new turn, or explicitly ask Codex to start or register it if that is what you want.

When the objective can surface findings that fail the goal's acceptance criteria, the generated prompt instructs the pursuing model to append each plausible off-goal finding to the single `leads/ledger.md` ledger following `leads/LEDGER-TEMPLATE.md` — recording the issue, why it is off-goal, its evidence state, and the blocker that would confirm it — and then continue the primary goal. Parked leads do not count toward success; they are preserved for follow-up goals.

## Updating and uninstalling

Because installation uses symlinks, updating this checkout updates the installed skill contents immediately. Start a new Codex turn to pick up changes.

To uninstall a skill, remove only its symlink from your Codex skills directory, for example:

```bash
rm ~/.codex/skills/goal-prompt
rm ~/.codex/skills/create-threat-model
```

If you installed through `$CODEX_HOME` or `--target`, remove the links from that directory instead.
