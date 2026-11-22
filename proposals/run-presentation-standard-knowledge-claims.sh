#!/usr/bin/env bash
# PROPOSED - not run. Additive change to throughline-presentation-standard (v2.3.0 -> v2.4.0).
# Run from the root of a clean clone, on a new branch.
set -euo pipefail
command -v tl >/dev/null || { echo "tl not found: install throughline 6.1.0 or later" >&2; exit 1; }

# tl allocates every UID. In a register that starts empty the number is known in
# advance, so each step states the UID it expects and the script stops the moment
# tl prints a different one, before anything is built on a wrong guess.
new() { # new <expected-uid> <rationale> <tl new arguments...>
  local want=$1 why=$2; shift 2
  local out; out=$(tl new "$@" --origin ai --no-interactive)
  echo "$out"
  case "$out" in
    "created $want "*) ;;
    *) echo "STOP: expected tl to create $want; nothing after this step has run" >&2; exit 1;;
  esac
  tl amend "$want" --rationale "$why" >/dev/null
}

# 1. Take the meta-standard edition that declares 'outside' links (meta ATTR-0040).
grep -q 'ref = "v1.0.0"' throughline.toml && sed -i.bak '0,/ref = "v1.0.0"/s//ref = "v1.2.0"/' throughline.toml && rm -f throughline.toml.bak

# 2. New link declaration
new LINK-0011 "Lets a slide show a knowledge graph's claim instead of a copy, so a deck and a document derived from one knowledge graph share each claim (knowledge INT-0001)." \
    LINK --type link --title "A slide derives from claims of a graph the series composes" --text "A slide derives from claims of a graph the series composes." --ground REG-0008 --ground-type from --attr "outside=true"
tl link LINK-0011 meta:LT-0001 --type via

# 3. Claims and sources become optional registers (amends two ratified items: they go ratified-stale)
tl amend REG-0010 --attr "required=false" --rationale "A claim is one statement a slide makes, resting on a source, and what kind of statement it is. Optional from v2.4.0: a series built from a knowledge graph shows that graph's claims (LINK-0011) and holds none of its own."
tl amend REG-0009 --attr "required=false" --rationale "A source is one document a claim rests on: where it is, who published it, when it was published and when it was last checked. A source may stand on its own. Optional from v2.4.0: a series built from a knowledge graph takes its sources from that graph."

tl check || true
