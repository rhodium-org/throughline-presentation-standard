# tl proposals 2026-11-22: presentation-standard-knowledge-claims

**Project:** rhodium-org/throughline-presentation-standard  
**Snapshot:** throughline 6.1.0 source; 2026-11-22  
**Status: PROPOSED - not run**

## Assumptions

- Written against throughline 6.1.0 source and presentation standard v2.3.0 (bb894c8); not run here.
- LINK-0011 is the next free LINK number (LINK-0010 is the highest).
- Bumping the meta pin from v1.0.0 to v1.2.0 is assumed additive (minor editions).

## Summary

| Step | Action | UID | Grounded on | Why |
|---|---|---|---|---|
| new | link | LINK-0011 (expected) | REG-0008 (from) | Lets a slide show a knowledge graph's claim instead of a copy, so a deck and a document derived from one knowledge graph share each claim (knowledge INT-0001). |
| amend | required=false | REG-0010 | - | A claim is one statement a slide makes, resting on a source, and what kind of statement it is. Optional from v2.4.0: a series built from a knowledge graph shows that graph's claims (LINK-0011) and holds none of its own. |
| amend | required=false | REG-0009 | - | A source is one document a claim rests on: where it is, who published it, when it was published and when it was last checked. A source may stand on its own. Optional from v2.4.0: a series built from a knowledge graph takes its sources from that graph. |

## Commands

Saved beside this sheet as `run-presentation-standard-knowledge-claims.sh`. Read it, then run it.

```bash
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

```

## Predicted `tl check` (PREDICTED)

```
[warn ] LINK-0011 unratified ai-origin item awaiting human ratification
[warn ] REG-0010 ratified-stale (amended after ratification)
[warn ] REG-0009 ratified-stale (amended after ratification)
```

Under `tl check --strict` each warning is an error, so expect exit 1 until every item is ratified.

## Ratification sheet

| UID | Title | Ratified by | Date |
|---|---|---|---|
| LINK-0011 | A slide derives from claims of a graph the series composes | | |
| REG-0010 | (re-ratify after amendment) | | |
| REG-0009 | (re-ratify after amendment) | | |

`tl ratify <UID> --by "<your own name>"`

Each person named above runs this themselves. I have not ratified anything and will not.

## Open questions and risks

- presentation-manager reads claims and their sources from the series itself. It will need to follow LINK-0011 into the composed knowledge graph before a derived deck renders its citations. That is app work, not a standard change.
- Additive, so a minor edition (v2.4.0): every series that conforms to v2.3.0 still conforms.
- The amendments make REG-0009 and REG-0010 ratified-stale until re-ratified.
