#!/usr/bin/env bash
# Run once per machine to replace standalone skills with Home Manager links.
set -euo pipefail

if [[ $# -ne 1 || ! $1 =~ ^[a-zA-Z0-9_@.-]+$ ]]; then
  echo "Usage: bash scripts/migrate-agent-skills.sh tkcd@snowcat" >&2
  exit 2
fi
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
target=$1
attr="$repo#homeConfigurations.\"$target\""
for tool in nix jq home-manager; do
  command -v "$tool" >/dev/null
done
configured_home=$(nix eval --raw "$attr.config.home.homeDirectory")
if [[ $configured_home != "$HOME" ]]; then
  echo "Refusing to migrate $HOME using a configuration for $configured_home" >&2
  exit 1
fi

# Finish building before moving any existing files.
nix build --no-link "$attr.activationPackage"
names=$(nix eval --json "$attr.config.programs.agent-skills.skills.explicit" --apply builtins.attrNames)
mapfile -t skills < <(jq -r '.[]' <<<"$names")
backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/skills-backups"
mkdir -p -- "$backup_root"
backup=$(mktemp -d "$backup_root/migration-XXXXXXXX")
printf '%s\n' "$names" > "$backup/skills.json"
printf 'Backup: %s\n' "$backup"

# Copy resolved content first, while relative links still point to the originals.
# Originals are also retained, including the original symlink text.
for agent in .agents .claude .codex; do
  for skill in "${skills[@]}"; do
    source="$HOME/$agent/skills/$skill"
    if [[ -e $source || -L $source ]]; then
      mkdir -p -- "$backup/content/$agent/skills" "$backup/original/$agent/skills"
      if [[ -e $source ]]; then
        cp -aL -- "$source" "$backup/content/$agent/skills/$skill"
      fi
    fi
  done
done
lock="$HOME/.agents/.skill-lock.json"
if [[ -f $lock ]]; then
  cp -a -- "$lock" "$backup/skill-lock.json"
  # Validate and prepare the remaining CLI-managed entries before mutation.
  jq --argjson names "$names" 'del(.skills[$names[]])' "$lock" > "$backup/remaining-skill-lock.json"
fi
for agent in .agents .claude .codex; do
  for skill in "${skills[@]}"; do
    source="$HOME/$agent/skills/$skill"
    if [[ -e $source || -L $source ]]; then
      mv -- "$source" "$backup/original/$agent/skills/$skill"
    fi
  done
done

if ! home-manager switch --flake "$repo#$target"; then
  printf 'Activation failed. Original files and resolved copies are preserved in %s\n' "$backup" >&2
  exit 1
fi
for agent in .agents .claude; do
  for skill in "${skills[@]}"; do
    resolved=$(readlink -f -- "$HOME/$agent/skills/$skill")
    [[ $resolved == /nix/store/* && -f $resolved/SKILL.md ]]
  done
done
for skill in "${skills[@]}"; do
  [[ ! -e $HOME/.codex/skills/$skill && ! -L $HOME/.codex/skills/$skill ]]
done
if [[ -f $backup/remaining-skill-lock.json ]]; then
  cp -- "$backup/remaining-skill-lock.json" "$lock"
fi
printf 'Migrated %s skills. Backup: %s\n' "${#skills[@]}" "$backup"
