#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/link-skills.sh [--target DIRECTORY] [SKILL_NAME ...]

Symlink repository skills into an agent's skills directory.

With no skill names, link every direct child directory containing SKILL.md.
The default destination is $CODEX_HOME/skills, or ~/.codex/skills when
CODEX_HOME is unset. Use --target to select another directory.
EOF
}

fail() {
  echo "error: $*" >&2
  exit 1
}

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "${script_dir}/.." && pwd -P)"
target_override=""
requested_skills=()

while (($# > 0)); do
  case "$1" in
    --target)
      (($# >= 2)) || fail "--target requires a directory"
      target_override="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      requested_skills+=("$@")
      break
      ;;
    -*)
      fail "unknown option: $1"
      ;;
    *)
      requested_skills+=("$1")
      shift
      ;;
  esac
done

if [[ -n "$target_override" ]]; then
  skills_dir="$target_override"
elif [[ -n "${CODEX_HOME:-}" ]]; then
  skills_dir="${CODEX_HOME}/skills"
else
  [[ -n "${HOME:-}" ]] || fail "HOME is unset; pass --target or set CODEX_HOME"
  skills_dir="${HOME}/.codex/skills"
fi

if ((${#requested_skills[@]} == 0)); then
  for manifest in "${repo_root}"/*/SKILL.md; do
    [[ -f "$manifest" ]] || continue
    requested_skills+=("$(basename -- "$(dirname -- "$manifest")")")
  done
fi

((${#requested_skills[@]} > 0)) || fail "no skill directories found in ${repo_root}"

skill_sources=()
skill_destinations=()
for skill_name in "${requested_skills[@]}"; do
  [[ "$skill_name" =~ ^[a-z0-9][a-z0-9-]*$ ]] || fail "invalid skill name: ${skill_name}"

  skill_path="${repo_root}/${skill_name}"
  [[ -f "${skill_path}/SKILL.md" ]] || fail "missing ${skill_name}/SKILL.md"

  skill_sources+=("$(cd -- "$skill_path" && pwd -P)")
  skill_destinations+=("${skills_dir}/${skill_name}")
done

if [[ -e "$skills_dir" && ! -d "$skills_dir" ]]; then
  fail "destination is not a directory: ${skills_dir}"
fi

has_conflict=0
for index in "${!skill_sources[@]}"; do
  source_path="${skill_sources[$index]}"
  destination_path="${skill_destinations[$index]}"

  if [[ -L "$destination_path" ]]; then
    existing_target="$(readlink -f -- "$destination_path" || true)"
    if [[ "$existing_target" != "$source_path" ]]; then
      echo "error: ${destination_path} points to ${existing_target:-an unresolved target}" >&2
      has_conflict=1
    fi
  elif [[ -e "$destination_path" ]]; then
    echo "error: refusing to replace existing path: ${destination_path}" >&2
    has_conflict=1
  fi
done

((has_conflict == 0)) || exit 1

mkdir -p -- "$skills_dir"

linked_count=0
for index in "${!skill_sources[@]}"; do
  source_path="${skill_sources[$index]}"
  destination_path="${skill_destinations[$index]}"

  if [[ -L "$destination_path" ]]; then
    echo "Already linked: ${destination_path}"
    continue
  fi

  ln -s -- "$source_path" "$destination_path"
  echo "Linked: ${destination_path} -> ${source_path}"
  ((linked_count += 1))
done

echo "Done: ${linked_count} new link(s). Skills are available to new turns."
