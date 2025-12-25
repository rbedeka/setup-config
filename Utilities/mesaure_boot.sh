#!/usr/bin/env bash
# measure_boot_times_luks.sh
# Usage: bash ~/measure_boot_times_luks.sh
# Produces LUKS timing metrics + systemd-analyze summaries.

set -euo pipefail

JOURNAL_CMD="journalctl -b -o short-monotonic --no-pager"

# Patterns (adjust if your system prints different strings)
PROMPT_PATTERN='systemd-ask-password.*(console|plymouth|Dispatch Password Requests|Forward Password Requests)'
END_PATTERNS=(
  'systemd-cryptsetup.*Set cipher'
  'Finished systemd-cryptsetup@'
  'Reached target cryptsetup.target'
)

# Helpers
first_line_for() {
  local pattern="$1"
  # Use -i for case-insensitive matching; keep pattern as passed
  $JOURNAL_CMD | grep -i -m1 -E "$pattern" || true
}

extract_monotonic_ts() {
  local line="$1"
  # line expected like: [    2.051768] rest...
  # extract number between [ and ]
  if [[ -z "$line" ]]; then
    echo ""
    return
  fi
  # sed prints the number
  echo "$line" | sed -n 's/^\[\s*\([0-9.]\+\)\].*/\1/p' || echo ""
}

# Find prompt line
PROMPT_LINE=$(first_line_for "$PROMPT_PATTERN")
PROMPT_TS=$(extract_monotonic_ts "$PROMPT_LINE")

# Find unlock/finish line from list of patterns
UNLOCK_LINE=""
UNLOCK_TS=""
for p in "${END_PATTERNS[@]}"; do
  l=$(first_line_for "$p")
  if [[ -n "$l" ]]; then
    UNLOCK_LINE="$l"
    UNLOCK_TS=$(extract_monotonic_ts "$UNLOCK_LINE")
    break
  fi
done

# Graphical target line
GRAPHICAL_LINE=$($JOURNAL_CMD | grep -i -m1 "Reached target graphical.target" || true)
GRAPHICAL_TS=$(extract_monotonic_ts "$GRAPHICAL_LINE")

# systemd-analyze parse: get initrd numeric token (e.g. "+ 12.986s (initrd)")
SA_LINE=$(systemd-analyze 2>/dev/null || echo "")
INITRD_SEC=""
if [[ -n "$SA_LINE" ]]; then
  # Try to extract " + <num>s (initrd)" pattern
  INITRD_SEC=$(echo "$SA_LINE" | sed -n 's/.*+ \([0-9.]*\)s (initrd).*/\1/p' || true)
fi
# fallback: try another sed that matches slightly different spacing
if [[ -z "$INITRD_SEC" ]]; then
  INITRD_SEC=$(echo "$SA_LINE" | sed -n 's/.*(\([0-9.]*\)s.*initrd.*).*/\1/p' || true)
fi
# final fallback to 0 if empty
if [[ -z "$INITRD_SEC" ]]; then
  INITRD_SEC="0"
fi

# convert timestamp strings to floats (awk)
to_f() { awk -v v="$1" 'BEGIN{ if(v=="") v=0; printf("%f", v)}'; }

pt=$(to_f "$PROMPT_TS")
ut=$(to_f "$UNLOCK_TS")
gt=$(to_f "$GRAPHICAL_TS")
initrd=$(to_f "$INITRD_SEC")

# Compute metrics
PAUSE_DUR=0
if [[ -n "$PROMPT_TS" && -n "$UNLOCK_TS" && "$PROMPT_TS" != "" && "$UNLOCK_TS" != "" ]]; then
  PAUSE_DUR=$(awk -v a="$pt" -v b="$ut" 'BEGIN{v=b-a; if(v<0) v=0; printf("%.6f", v)}')
fi

PURE_INITRD=0
if (( $(echo "$initrd > 0" | bc -l) )); then
  PURE_INITRD=$(awk -v i="$initrd" -v p="$PAUSE_DUR" 'BEGIN{v=i-p; if(v<0) v=0; printf("%.6f", v)}')
fi

POST_UNLOCK=0
if [[ -n "$UNLOCK_TS" && -n "$GRAPHICAL_TS" && "$UNLOCK_TS" != "" && "$GRAPHICAL_TS" != "" ]]; then
  POST_UNLOCK=$(awk -v a="$ut" -v b="$gt" 'BEGIN{v=b-a; if(v<0) v=0; printf("%.6f", v)}')
fi

HARDWARE_ONLY=0
if [[ -n "$PROMPT_TS" && "$PROMPT_TS" != "" ]]; then
  HARDWARE_ONLY=$(awk -v a="$pt" 'BEGIN{printf("%.6f", a)}')
fi

# Output everything
echo
echo "================== LUKS & INITRD TIMING SUMMARY =================="
echo "Prompt line (first match):"
echo "  ${PROMPT_LINE:-<not found>}"
echo "Unlock line (first match):"
echo "  ${UNLOCK_LINE:-<not found>}"
echo "Graphical target line (first match):"
echo "  ${GRAPHICAL_LINE:-<not found>}"
echo
echo "Detected monotonic timestamps (seconds):"
printf "  LUKS prompt time:        %s\n" "${PROMPT_TS:-<n/a>}"
printf "  Unlock completion time:  %s\n" "${UNLOCK_TS:-<n/a>}"
printf "  Graphical reached time:  %s\n" "${GRAPHICAL_TS:-<n/a>}"
printf "  systemd-analyze initrd:  %s s\n" "$initrd"
echo
echo "Computed metrics (seconds):"
printf "  Detected LUKS pause (prompt -> unlock):   %s s\n" "$PAUSE_DUR"
printf "  Pure initrd (initrd - LUKS pause):        %s s\n" "$PURE_INITRD"
printf "  Post-unlock (unlock -> graphical):       %s s\n" "$POST_UNLOCK"
printf "  Hardware-only (time to prompt):          %s s\n" "$HARDWARE_ONLY"
echo
echo "Notes:"
echo " - If any of the detected lines are '<not found>', re-run this script with sudo (journalctl may require it)."
echo " - Pure initrd is derived from systemd-analyze's reported initrd; if that token is missing, Pure initrd will be 0."
echo
echo "================== systemd-analyze outputs =================="
echo
echo "TOTAL BOOT TIME (systemd-analyze):"
systemd-analyze || true
echo
echo "SLOWEST SERVICES (top 20):"
systemd-analyze blame | sed -n '1,20p' || true
echo
echo "CRITICAL CHAIN:"
systemd-analyze critical-chain || true
echo
echo "================== Relevant journal excerpt (for eyeballing) =="
echo
echo "Recent journal lines around LUKS/cryptsetup/prompts (short-monotonic):"
# show a window of lines around the prompt and unlock if found
if [[ -n "$PROMPT_TS" ]]; then
  # show 10 lines before and after prompt match
  $JOURNAL_CMD | grep -i -n -E "$PROMPT_PATTERN" -m1 | cut -d: -f1 | {
    read -r ln || true
    if [[ -n "$ln" ]]; then
      start=$(( ln > 10 ? ln-10 : 1 ))
      $JOURNAL_CMD | sed -n "${start},$((ln+10))p"
    fi
  }
else
  echo "  (prompt pattern not found; try running with sudo)"
fi

echo
echo "Lines around unlock/completion match:"
if [[ -n "$UNLOCK_LINE" ]]; then
  $JOURNAL_CMD | grep -i -n -E "${END_PATTERNS[0]}\|${END_PATTERNS[1]}\|${END_PATTERNS[2]}" -m1 | cut -d: -f1 | {
    read -r ul || true
    if [[ -n "$ul" ]]; then
      start=$(( ul > 10 ? ul-10 : 1 ))
      $JOURNAL_CMD | sed -n "${start},$((ul+10))p"
    fi
  }
else
  echo "  (unlock/completion pattern not found; try running with sudo)"
fi

echo
echo "================== End of report =================="
echo

# Exit
exit 0
