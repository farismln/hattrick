# Installation

This file is written for an LLM agent. The user has pointed you at it so you
will install this repository's skills into the skills directory that the
harness you are running in actually reads. Follow these instructions directly;
you do not need to read anything else in the repository to comply.

## What you are installing

Every direct child directory of this repository (the directory containing this
file) that contains a `SKILL.md` file is one skill — currently
`create-threat-model` and `goal-prompt`. Installing a skill means exposing its
directory to your harness by symlink, so future updates to this checkout are
picked up automatically. Nothing is copied elsewhere, compiled, or executed.

## Steps

1. Identify the repository root: the directory containing this file.

2. Determine the skills directory for the harness you are running in:

   | Harness | Skills directory |
   | --- | --- |
   | ZCode | `~/.agents/skills` |
   | Codex CLI, Codex IDE extension, ChatGPT desktop | `$CODEX_HOME/skills` if `CODEX_HOME` is set, otherwise `~/.codex/skills` |
   | Claude Code | `~/.claude/skills` |
   | Other agents following the shared convention | `~/.agents/skills` |

   If you are not a listed harness and cannot verify where your harness reads
   skills from, ask the user rather than guessing. Never install into more
   than one directory.

3. For each skill directory found in step 1, create a symlink from
   `<skills-directory>/<skill-name>` to the skill's absolute path in this
   repository. Create the skills directory first if it does not exist.

4. Apply these conflict rules to any destination that already exists —
   the same rules `scripts/link-skills.sh` enforces:

   - An existing symlink already pointing at this repository's same skill
     directory means the skill is already installed; leave it and report it
     as such.
   - An existing symlink pointing anywhere else, or any existing file or
     directory at the destination, must not be replaced. Report the conflict
     and ask the user before touching it.

5. Verify: each destination resolves and its `SKILL.md` is readable through
   the link. Report which skills were linked, which were already present,
   and any conflicts you did not resolve.

Skills take effect in new turns; the user may need to start one.

## Notes

- If your environment cannot create reliable symlinks, copying the skill
  directories is an acceptable fallback — but warn the user that copies will
  not track future updates to this checkout.
- If bash is available and the skills directory is known, running
  `./install.sh --target <skills-directory>` from the repository root performs
  the same installation with the same conflict rules.
