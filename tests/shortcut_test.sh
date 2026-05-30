#!/usr/bin/env bash
set -euo pipefail

script=${1:-sing-box.sh}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

shortcut_body=$(sed -n '/^create_shortcut() {/,/^}/p' "$script")
grep -F 'https://raw.githubusercontent.com/gamilian/sing-box/main/sing-box.sh' <<< "$shortcut_body" >/dev/null || fail 'sb shortcut does not use the gamilian repository'
grep -F 'https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh' <<< "$shortcut_body" >/dev/null && fail 'sb shortcut still uses the upstream fscarmen repository'
grep -F 'mkdir -p ${WORK_DIR}' <<< "$shortcut_body" >/dev/null || fail 'create_shortcut does not ensure WORK_DIR exists before writing sb.sh'

grep -F '[ "${STATUS[0]}" != "$(text 26)" ] && create_shortcut' "$script" >/dev/null || fail 'installed systems do not repair missing /usr/bin/sb before opening the menu'

printf 'PASS: sb shortcut creation is wired\n'
