#!/usr/bin/env bash
# Truth-table test for the succession fixes (24 Aug 2026):
#   · parked() debounce — Escape only on the 2nd consecutive sighting
#   · BOOT-CORPSE fast retry — API 5xx + never-beaten heartbeat, 3 signals required
#   · rotate young-skip — a session under ROTATE_MIN_AGE is not replaced
# SAFE BY CONSTRUCTION (same pattern as test-memory-guard.sh):
#   · throwaway tmux session (cs-itest), never Marc's cs-manager
#   · state prefix redirected → the real heartbeat/marker/parkseen files are never touched
#   · CLAUDEMANAGER_NO_START=1 → no claude session is ever spawned
#   · memory values INJECTED → no dependence on real box state
set -u
CM="$HOME/.local/bin/claudemanager"
TS="${TMPDIR:-/tmp}/itest-state/itest"
mkdir -p "$(dirname "$TS")"
export CLAUDEMANAGER_SESSION=cs-itest
export CLAUDEMANAGER_STATE="$TS"
export CLAUDEMANAGER_NO_START=1
export CLAUDEMANAGER_CLOSE_SHA="$TS.closesha"
MEMOK() { CLAUDEMANAGER_FAKE_RSS_KB=$((600*1024)) CLAUDEMANAGER_FAKE_CHILD_KB=$((100*1024)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((10*1048576)) "$@"; }
PASS=0; FAIL=0

reset_state() { rm -f "$TS".* ; touch "$TS.heartbeat"; : > "$TS.closesha"; }
mk_clean()  { tmux kill-session -t cs-itest 2>/dev/null; tmux new-session -d -s cs-itest "sleep 3600"; sleep 1; }
mk_parked() { tmux kill-session -t cs-itest 2>/dev/null; tmux new-session -d -s cs-itest "bash -c 'printf \"❯ 1. Yes, set it up for me\\n\"; exec sleep 3600'"; sleep 1; }
mk_529()    { tmux kill-session -t cs-itest 2>/dev/null; tmux new-session -d -s cs-itest "bash -c 'printf \"API Error: 529 Overloaded. This is a server-side issue.\\n\"; exec sleep 3600'"; sleep 1; }
run_wd()    { MEMOK $CM watchdog 2>&1; }
ck() { # ck <name> <expected-substring|!absent-substring> <haystack>
  local name="$1" want="$2" hay="$3"
  if [ "${want:0:1}" = "!" ]; then
    if grep -qF -- "${want:1}" <<<"$hay"; then echo "❌ FAIL $name (found forbidden: ${want:1})"; FAIL=$((FAIL+1)); else echo "✅ PASS $name"; PASS=$((PASS+1)); fi
  else
    if grep -qF -- "$want" <<<"$hay"; then echo "✅ PASS $name"; PASS=$((PASS+1)); else echo "❌ FAIL $name (missing: $want)"; echo "   got: $hay"; FAIL=$((FAIL+1)); fi
  fi
}
alive_test() { tmux has-session -t cs-itest 2>/dev/null && echo ALIVE || echo DEAD; }

echo "══════ 1. PARKED DEBOUNCE — suspect first, shoot second ══════"
reset_state; mk_parked
OUT=$(run_wd)
ck "1a first sighting = suspected"    "dialog suspected"     "$OUT"
ck "1b first sighting = NO Escape"    "!sending Escape"      "$OUT"
ck "1c parkseen stamped"              "1"                    "$([ -f "$TS.parkseen" ] && echo 1 || echo 0)"
ck "1d session survives"              "ALIVE"                "$(alive_test)"
OUT2=$(run_wd)
ck "1e second sighting = Escape"      "2nd consecutive sighting"  "$OUT2"
ck "1f Escape actually sent"          "sending Escape"       "$OUT2"

echo "══════ 2. FALSE POSITIVE CLEARS ITSELF — no keys ever sent ══════"
reset_state; mk_parked
OUT=$(run_wd)                          # sighting 1: suspected
mk_clean                               # the "dialog" was transient — next look it is gone
OUT2=$(run_wd)
ck "2a no Escape on run 1"            "!sending Escape"      "$OUT"
ck "2b no Escape on run 2"            "!sending Escape"      "$OUT2"
ck "2c parkseen cleared"              "0"                    "$([ -f "$TS.parkseen" ] && echo 1 || echo 0)"
ck "2d session survives"              "ALIVE"                "$(alive_test)"

echo "══════ 3. BOOT-CORPSE — 5xx + stale + never-beaten = fast replace ══════"
reset_state; mk_529
touch -d '20 minutes ago' "$TS.heartbeat"    # stale AND older than birth+120 (born just now… mtime past = never beaten)
OUT=$(run_wd)
ck "3a boot-corpse detected"          "BOOT-CORPSE"          "$OUT"
ck "3b session replaced"              "DEAD"                 "$(alive_test)"
ck "3c NO marker (confession path)"   "NONE"                 "$($CM handover-check)"

echo "══════ 4. BOOT-CORPSE GUARDS — each missing signal blocks the kill ══════"
reset_state; mk_529                    # 4a: banner but FRESH heartbeat → live
OUT=$(run_wd)
ck "4a fresh heartbeat blocks"        "!BOOT-CORPSE"         "$OUT"
ck "4b session survives"              "ALIVE"                "$(alive_test)"
reset_state; mk_clean                  # 4c: stale heartbeat but NO banner → live
touch -d '20 minutes ago' "$TS.heartbeat"
OUT=$(run_wd)
ck "4c no banner blocks"              "!BOOT-CORPSE"         "$OUT"
ck "4d session survives"              "ALIVE"                "$(alive_test)"
reset_state; mk_529                    # 4e: banner + stale, but heartbeat BEAT after birth
touch -d '20 minutes ago' "$TS.heartbeat"                    # (quoted-error scenario: a working manager printed the string)
OUT=$(CLAUDEMANAGER_FAKE_BORN=$(( $(date +%s) - 7200 )) run_wd)
ck "4e beaten-since-birth blocks"     "!BOOT-CORPSE"         "$OUT"
ck "4f session survives"              "ALIVE"                "$(alive_test)"

echo "══════ 5. ROTATE YOUNG-SKIP — a fresh session is not churned ══════"
reset_state; mk_clean
OUT=$($CM rotate 2>&1)
ck "5a skip logged"                   "SKIPPING replacement" "$OUT"
ck "5b session survives"              "ALIVE"                "$(alive_test)"
ck "5c no marker set"                 "NONE"                 "$($CM handover-check)"
sleep 3                                # 5d: with the threshold lowered, rotate proceeds
OUT=$(CLAUDEMANAGER_ROTATE_MIN_AGE=2 $CM rotate 2>&1)
ck "5d rotates past threshold"        "clean recycle"        "$OUT"
ck "5e session killed"                "DEAD"                 "$(alive_test)"
ck "5f marker = rotate"               "CLEAN rotate"         "$($CM handover-check --consume)"

echo "══════ 6. REGRESSION — clean healthy session: watchdog does nothing ══════"
reset_state; mk_clean
OUT=$(run_wd)
ck "6a no dialog suspicion"           "!dialog suspected"    "$OUT"
ck "6b no Escape"                     "!Escape"              "$OUT"
ck "6c no boot-corpse"                "!BOOT-CORPSE"         "$OUT"
ck "6d session survives"              "ALIVE"                "$(alive_test)"

tmux kill-session -t cs-itest 2>/dev/null
echo
echo "════════════════════════════════════════"
echo "   PASSED: $PASS   FAILED: $FAIL"
echo "════════════════════════════════════════"
[ "$FAIL" -eq 0 ]
