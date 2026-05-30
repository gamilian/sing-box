#!/usr/bin/env bash
set -euo pipefail

script=${1:-sing-box.sh}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

grep -F 'alias ${WORK_DIR}/subscribe/\$path1;' "$script" >/dev/null || fail 'auto template 1 alias missing'
grep -F 'alias ${WORK_DIR}/subscribe/\$path2;' "$script" >/dev/null || fail 'auto template 2 alias missing'
grep -E '~\*Surge[[:space:]]+/surge' "$script" >/dev/null || fail 'Surge user-agent is not routed to /surge'
grep -F '> ${WORK_DIR}/subscribe/surge-proxies' "$script" >/dev/null || fail 'surge-proxies subscription is not generated'
grep -F '> ${WORK_DIR}/subscribe/surge' "$script" >/dev/null || fail 'surge profile subscription is not generated'
grep -F '$SUBSCRIBE_ADDRESS/${UUID_CONFIRM}/surge' "$script" >/dev/null || fail 'Surge subscription link is not exported'
grep -F '$SUBSCRIBE_ADDRESS/${UUID_CONFIRM}/surge-proxies' "$script" >/dev/null || fail 'Surge policy-path link is not exported'
grep -F 'hysteria2,' "$script" >/dev/null || fail 'Surge Hysteria 2 proxy line missing'
grep -F 'tuic-v5,' "$script" >/dev/null && fail 'Surge export must not use unsupported tuic-v5 proxy type'
grep -F 'Surge export skips sing-box TUIC v5' "$script" >/dev/null || fail 'Surge TUIC v5 skip note missing'
grep -F '[[ "$SHADOWTLS_METHOD" != 2022-* ]]' "$script" >/dev/null || fail 'Surge ShadowTLS export must skip SS2022 methods'
grep -F '[[ "$SHADOWSOCKS_METHOD" != 2022-* ]]' "$script" >/dev/null || fail 'Surge Shadowsocks export must skip SS2022 methods'
grep -F 'Surge AnyTLS is version-gated' "$script" >/dev/null || fail 'Surge AnyTLS version gate note missing'

printf 'PASS: Surge subscription generation is wired\n'
