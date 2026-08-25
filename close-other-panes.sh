#!/bin/sh

set -eu

herdr="${HERDR_BIN_PATH:-herdr}"

if [ -z "${HERDR_PANE_ID:-}" ]; then
  echo "close-other-panes: no HERDR_PANE_ID, invoke this action from a pane" >&2
  exit 1
fi

if ! layout="$("$herdr" pane layout --pane "$HERDR_PANE_ID" 2>&1)"; then
  echo "close-other-panes: $layout" >&2
  exit 1
fi

# pane layout is already scoped to the tab of the invoking pane
pane_ids="$(
  printf '%s' "$layout" |
  grep -o '"pane_id":"[^"]*"' |
  sed 's/.*:"//; s/"$//'
)" || pane_ids=""

# a missing self id means the parse broke, and the exclusion below would then close this pane
if ! printf '%s\n' "$pane_ids" | grep -qxF "$HERDR_PANE_ID"; then
  echo "close-other-panes: $HERDR_PANE_ID not found in the tab layout, closing nothing" >&2
  exit 1
fi

others="$(printf '%s\n' "$pane_ids" | grep -vxF "$HERDR_PANE_ID")" || others=""

[ -n "$others" ] || exit 0

printf '%s\n' "$others" | {
  status=0
  while IFS= read -r pane_id; do
    if ! output="$("$herdr" pane close "$pane_id" </dev/null 2>&1)"; then
      echo "close-other-panes: failed to close $pane_id: $output" >&2
      status=1
    fi
  done
  exit "$status"
}
