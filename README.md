# Hattrick

Hattrick is a small collection of reusable agent skills for security-audit planning and goal definition. It currently includes:

| Skill | Purpose |
| --- | --- |
| `create-threat-model` | Turns completed audit context into an evidence-bound `threat-model.md`, including assets, invariants, actors, trust boundaries, lifecycle models, and testable threat hypotheses. It does not hunt for or report vulnerabilities. |
| `goal-prompt` | Rewrites an objective and its available context as a precise, copy-paste-ready persistent goal prompt with explicit acceptance, evidence, scope, and completion conditions. It does not execute or register the resulting goal. |

Each skill is stored in its own directory as a `SKILL.md` file. The installer makes the skills available to an agent by symlinking those directories into its skills directory, so changes made in this checkout are reflected without reinstalling.

## Requirements

- An agent with standalone skill support (for example, Codex CLI, the Codex IDE extension, or the ChatGPT desktop app)
- Bash on Linux or another Unix-like environment
- A local checkout of this repository

## Installation

From the repository root, install every included skill:

```bash
./install.sh
```

By default, the installer links skills into `~/.agents/skills`; when `CODEX_HOME` is set it uses `$CODEX_HOME/skills` instead. Skills become available in new turns.

To install through an agent instead of the script, point it at [INSTALLATION.md](INSTALLATION.md): it contains self-contained instructions the agent follows to detect its own harness and link the skills into that harness's skills directory, with the same conflict rules.

To install only selected skills, pass their directory names:

```bash
./install.sh goal-prompt
./install.sh create-threat-model goal-prompt
```

To use a different skills directory, pass `--target`:

```bash
./install.sh --target /path/to/skills
```

The installer is idempotent when a skill is already linked to this checkout. For safety, it refuses to replace an existing file, directory, or symlink that points somewhere else; move or remove that conflicting destination yourself before retrying.

Run `./install.sh --help` to see all installer options.

## Usage

Start a new turn and invoke a skill by name with `$skill-name`. Depending on the client, you can also run `/skills` to browse installed skills.

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

Give the agent the objective plus any relevant repository or threat-model context:

```text
Use $goal-prompt to turn this objective into a precise persistent goal: find one novel, high-impact vulnerability in the in-scope contracts and provide a reproducible proof.
```

The response is a self-contained goal prompt of at most two paragraphs. Copy it into a new turn, or explicitly ask the agent to start or register it if that is what you want.

## Updating and uninstalling

Because installation uses symlinks, updating this checkout updates the installed skill contents immediately. Start a new turn to pick up changes.

To uninstall a skill, remove only its symlink from your skills directory, for example:

```bash
rm ~/.agents/skills/goal-prompt
rm ~/.agents/skills/create-threat-model
```

If you installed through `CODEX_HOME` or `--target`, remove the links from that directory instead.
