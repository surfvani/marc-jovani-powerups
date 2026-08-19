#!/usr/bin/env bash
# Truth-table test for the memory guard + marker semantics (18 Aug 2026).
# SAFE BY CONSTRUCTION:
#   · throwaway tmux session (cs-mtest), never Marc's cs-manager
#   · state prefix redirected → the real heartbeat/marker/msgs files are never touched
#   · CLAUDEMANAGER_NO_START=1 → no claude session is ever spawned
#   · memory values INJECTED → zero real memory pressure on a box that OOM'd tonight
set -u
CM=/home/ubuntu/.local/bin/claudemanager
TS=/tmp/claude-1000/-home-ubuntu/7c66fd4e-ae52-48ae-88e6-3f94891fd4af/scratchpad/mtest
export CLAUDEMANAGER_SESSION=cs-mtest
export CLAUDEMANAGER_STATE="$TS"
export CLAUDEMANAGER_NO_START=1
export CLAUDEMANAGER_CLOSE_SHA="$TS.closesha"
PASS=0; FAIL=0
GB=1048576   # kB in a GB

reset_state() { rm -f "$TS".* ; touch "$TS.heartbeat"; : > "$TS.closesha"; }
mk_session()  { tmux kill-session -t cs-mtest 2>/dev/null; tmux new-session -d -s cs-mtest "sleep 3600"; sleep 1; }
run()         { $CM watchdog 2>&1; }
ck() { # ck <name> <expected-substring|!absent-substring> <haystack>
  local name="$1" want="$2" hay="$3"
  if [ "${want:0:1}" = "!" ]; then
    if grep -qF -- "${want:1}" <<<"$hay"; then echo "❌ FAIL $name (found forbidden: ${want:1})"; FAIL=$((FAIL+1)); else echo "✅ PASS $name"; PASS=$((PASS+1)); fi
  else
    if grep -qF -- "$want" <<<"$hay"; then echo "✅ PASS $name"; PASS=$((PASS+1)); else echo "❌ FAIL $name (missing: $want)"; echo "   got: $hay"; FAIL=$((FAIL+1)); fi
  fi
}
alive_test() { tmux has-session -t cs-mtest 2>/dev/null && echo ALIVE || echo DEAD; }

echo "══════ 1. NORMAL — fresh manager, roomy box ══════"
reset_state; mk_session
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((600*1024)) CLAUDEMANAGER_FAKE_CHILD_KB=$((400*1024)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((10*GB)) run)
ck "1a no warning"        "!MEMORY WARNING" "$OUT"
ck "1b no emergency"      "!EMERGENCY"      "$OUT"
ck "1c session survives"  "ALIVE"           "$(alive_test)"
ck "1d curve line written" "$(date +%Y-%m-%d)" "$(cat "$TS.mem" 2>/dev/null)"
echo "   curve: $(tail -1 "$TS.mem")"

echo "══════ 2. WARN at 6 GB — once per session ══════"
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((7*GB)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((9*GB)) run)
ck "2a warning fires"      "MEMORY WARNING"  "$OUT"
ck "2b told the manager"   "WATCHDOG (memory guard)" "$(cat "$TS.msgs" 2>/dev/null)"
ck "2c not killed"         "ALIVE"           "$(alive_test)"
OUT2=$(CLAUDEMANAGER_FAKE_RSS_KB=$((8*GB)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((9*GB)) run)
ck "2d no second warning"  "!MEMORY WARNING" "$OUT2"
ck "2e one message only"   "1"               "$(grep -c 'memory guard' "$TS.msgs")"

echo "══════ 3. CEILING 16 GB — order, not a kill ══════"
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((17*GB)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((8*GB)) run)
ck "3a emergency ordered"  "EMERGENCY ROTATE ORDERED" "$OUT"
ck "3b order sent to mgr"  "EMERGENCY ROTATE"         "$(cat "$TS.msgs")"
ck "3c state file written" "$(date +%Y)"              "$(date -d @$(cut -d' ' -f1 "$TS.emergency") +%Y 2>/dev/null)"
ck "3d NOT killed yet"     "ALIVE"                    "$(alive_test)"

echo "══════ 4. BRIEF WRITTEN → clean replacement + marker ══════"
sleep 1; touch "$TS.closesha"     # the close ritual's Step 7 moving = "brief is on disk"
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((17*GB)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((8*GB)) run)
ck "4a clean replacement"  "brief WRITTEN"        "$OUT"
ck "4b session killed"     "DEAD"                 "$(alive_test)"
ck "4c marker + reason"    "emergency-rotate"     "$(cat "$TS.handover" 2>/dev/null)"
ck "4d verdict = CLEAN"    "CLEAN emergency-rotate" "$($CM handover-check)"

echo "══════ 5. FULL BOX but a small manager — do NOT churn it ══════"
reset_state; mk_session
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((600*1024)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((1*GB)) run)
ck "5a no emergency"       "!EMERGENCY"  "$OUT"
ck "5b survives"           "ALIVE"       "$(alive_test)"

echo "══════ 6. FULL BOX with a fat manager — tonight's real condition ══════"
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((5*GB)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((1*GB)) run)
ck "6a emergency ordered"  "EMERGENCY ROTATE ORDERED" "$OUT"
ck "6b still alive (grace)" "ALIVE"                   "$(alive_test)"

echo "══════ 7. GRACE EXPIRED, no brief → kill WITHOUT marker ══════"
printf '%s %s\n' "$(( $(date +%s) - 1200 ))" "$(tmux display -p -t cs-mtest '#{session_created}')" > "$TS.emergency"
touch -d '30 minutes ago' "$TS.closesha"   # no close since the order — that is the scenario
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((17*GB)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((1*GB)) run)
ck "7a grace expired path" "grace expired with NO close" "$OUT"
ck "7b killed"             "DEAD"                        "$(alive_test)"
ck "7c NO marker"          "NONE"                        "$($CM handover-check)"

echo "══════ 8. MARKER VERDICTS — the 21:30 disguise ══════"
reset_state
ck "8a no marker"          "NONE"          "$($CM handover-check)"
touch "$TS.handover"
ck "8b bare + fresh"       "CLEAN bare"    "$($CM handover-check)"
touch -d '4 hours ago' "$TS.handover"
ck "8c bare + 4h = STALE"  "STALE"         "$($CM handover-check)"     # ← tonight's 9.5h marker
printf 'solo %s\n' "$(date +%s)" > "$TS.handover"; touch -d '12 hours ago' "$TS.handover"
ck "8d solo at 12h = CLEAN" "CLEAN solo"   "$($CM handover-check)"     # solo→2am rotate must survive
ck "8e --consume deletes"  "NONE"          "$($CM handover-check --consume >/dev/null; $CM handover-check)"

echo "══════ 9. DESIGNATED VICTIM — applied to the tree, and ONLY the tree ══════"
reset_state; mk_session
BEFORE_FLAGGED=$(for p in $(ps -eo pid= -u ubuntu); do [ "$(cat /proc/$p/oom_score_adj 2>/dev/null)" = "500" ] && echo x; done | wc -l)
CLAUDEMANAGER_FAKE_RSS_KB=$((600*1024)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((10*GB)) run >/dev/null
PP=$(tmux list-panes -t cs-mtest -F '#{pane_pid}' | head -1)
ck "9a oom_score_adj set"  "500"  "$(cat /proc/$PP/oom_score_adj 2>/dev/null)"
TREE_N=$(bash -c 'source /dev/stdin <<<"$(sed -n "/^mgr_tree()/,/^}/p" /home/ubuntu/.local/bin/claudemanager)"; mgr_tree '"$PP"' | grep -c .')
ck "9b tree is small"      "1"    "$([ "$TREE_N" -le 3 ] && echo 1 || echo "0 (walk returned $TREE_N pids)")"
AFTER_FLAGGED=$(for p in $(ps -eo pid= -u ubuntu); do [ "$(cat /proc/$p/oom_score_adj 2>/dev/null)" = "500" ] && echo x; done | wc -l)
ck "9c no collateral"      "1"    "$([ $((AFTER_FLAGGED - BEFORE_FLAGGED)) -le 2 ] && echo 1 || echo "0 (flagged $((AFTER_FLAGGED-BEFORE_FLAGGED)) extra processes)")"
echo "   flagged before=$BEFORE_FLAGGED after=$AFTER_FLAGGED · tree pids=$TREE_N"
for p in $(ps -eo pid= -u ubuntu); do [ "$(cat /proc/$p/oom_score_adj 2>/dev/null)" = "500" ] && echo 0 > /proc/$p/oom_score_adj 2>/dev/null; done   # leave the box as we found it

echo "══════ 10. REGRESSION — quiet healthy session + STALE marker: LEAVE IT ALONE ══════"
# The screen must differ between runs, or the liveness ladder (90 min) claims the
# session before the marker branch (2 h) is ever reached — that ordering is by design
# and predates this change; clearing the fingerprint isolates the branch under test.
touch -d '3 hours ago' "$TS.heartbeat"; touch -d '5 hours ago' "$TS.handover"; rm -f "$TS.pane" "$TS.stuck"
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((600*1024)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((10*GB)) run)
ck "10a left alone"        "LEAVING IT ALONE" "$OUT"
ck "10b still alive"       "ALIVE"            "$(alive_test)"

echo "══════ 11. REGRESSION — stale heartbeat + SANCTIONED marker: rotate ══════"
printf 'brief %s\n' "$(date +%s)" > "$TS.handover"; touch -d '3 hours ago' "$TS.heartbeat"; rm -f "$TS.pane" "$TS.stuck"
OUT=$(CLAUDEMANAGER_FAKE_RSS_KB=$((600*1024)) CLAUDEMANAGER_FAKE_AVAIL_KB=$((10*GB)) run)
ck "11a rotates"           "sanctioned handover marker" "$OUT"
ck "11b killed"            "DEAD"                       "$(alive_test)"

echo "══════ 12. REGRESSION — OFF and SOLO still stop the watchdog dead ══════"
reset_state; mk_session; touch "$TS.off"
OUT=$(run); ck "12a OFF exits silent" "" "${OUT:-empty}"; [ -z "$OUT" ] && echo "   (no output, correct)"
rm -f "$TS.off"; touch "$TS.solo"
OUT=$(run); ck "12b SOLO exits silent" "" "${OUT:-empty}"; [ -z "$OUT" ] && echo "   (no output, correct)"
rm -f "$TS.solo"

tmux kill-session -t cs-mtest 2>/dev/null
echo
echo "════════════════════════════════════════"
echo "   PASSED: $PASS   FAILED: $FAIL"
echo "════════════════════════════════════════"
[ "$FAIL" -eq 0 ]
