#!/bin/sh

set -eu

herdr="${HERDR_BIN_PATH:-herdr}"

if [ -z "${HERDR_PANE_ID:-}" ]; then
  echo "close-other-panes: no HERDR_PANE_ID, invoke this action from a pane" >&2
  exit 1
fi

layout="$("$herdr" pane layout --pane "$HERDR_PANE_ID")"

# pane layout is already scoped to the tab of the invoking pane
others="$(
  printf '%s' "$layout" |
  grep -o '"pane_id":"[^"]*"' |
  sed 's/.*:"//; s/"$//' |
  grep -vxF "$HERDR_PANE_ID"
)" || others=""

[ -n "$others" ] || exit 0

printf '%s\n' "$others" | {
  status=0
  while IFS= read -r pane_id; do
    "$herdr" pane close "$pane_id" </dev/null >/dev/null || {
      echo "close-other-panes: failed to close $pane_id" >&2
      status=1
    }
  done
  exit "$status"
}
