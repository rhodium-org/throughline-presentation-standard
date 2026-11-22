#!/usr/bin/env bash
# PROPOSED - test-run in a scratch copy on 22 Nov 2026 with tl 6.1.0; nothing ratified.
# Change to throughline-presentation-standard, v2.3.0 -> v3.0.0 (breaking: the draft status goes).
# Run from the root of a clean clone of the branch claude/knowledge-claims-v3.0.0.
set -euo pipefail
command -v tl >/dev/null || { echo "tl not found: install throughline 6.1.0 or later" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "working tree not clean: commit or stash first" >&2; exit 1; }

# 1. Take the meta-standard edition that declares 'outside' links (meta ATTR-0040).
#    It is also the edition that retires the draft status (meta v1.2.0, UR-0046), and no
#    edition has one without the other, so steps 2-4 retire draft here too.
sed -i.bak '0,/ref = "v1.0.0"/s//ref = "v1.2.0"/' throughline.toml && rm -f throughline.toml.bak
grep -q 'ref = "v1.2.0"' throughline.toml || { echo "STOP: meta pin not moved to v1.2.0" >&2; exit 1; }

# 2. The moves between statuses (RULE-0054) without draft. A rejected item goes back to
#    proposed, where draft used to take it.
sed -i.bak \
  -e 's/^# draft = actively moving toward approval; deferred = /# deferred = /' \
  -e '/^draft *= /d' \
  -e 's/^\(proposed *= \["\)draft", "/\1/' \
  -e 's/^\(deferred *= \["proposed", \)"draft", /\1/' \
  -e 's/^\(rejected *= \["\)draft"/\1proposed"/' \
  throughline.toml && rm -f throughline.toml.bak
! grep -q '"draft"' throughline.toml || { echo "STOP: draft still named in throughline.toml" >&2; exit 1; }
tl check >/dev/null || { echo "STOP: standard does not load after retiring draft" >&2; exit 1; }

# 3. The conformance examples follow this standard, so their draft items become proposed.
#    tl migrate does three of them; wide-layout fails to load by design (EX-0003), so its
#    items are moved the same way by hand.
git commit -qm "scratch: pin meta v1.2.0" -- throughline.toml   # migrate refuses uncommitted graphs
tl migrate --beneath conformance --apply
sed -i 's/^status: draft$/status: proposed/' conformance/wide-layout/*/*.yml
git reset -q --soft HEAD~1                                      # leave every change uncommitted for review
#    tl 6.1.0 quotes the bad value with double quotes; check.sh expected single ones,
#    so EX-0002 already failed on main.
sed -i "s/\"attribute 'checked' is declared date but holds 'next tuesday'\"/'checked: \"next tuesday\" is not a date'/" conformance/check.sh
bash conformance/check.sh

# 4. RULE-0054 names draft, so it is amended (goes ratified-stale until re-signed).
tl amend RULE-0054 --text "Every item in a series graph moves through the statuses proposed, deferred, ratified, implemented, verified, suspect, rejected and deleted, along the transitions the standard declares, with proposed born and put forward, ratified signed, rejected invalidated, suspect withdrawn and deleted tombstoned. Only a person's ratification makes an item signed; no status stands for agreement without one." \
  --rationale "Declared in throughline.toml under [status], [status.roles] and [transitions]. approved was removed on 7 November 2026: the graph tool gives it no role (nothing writes or reads it), so it could only ever claim an agreement no signature records, and the presentation manager counted it as signed. draft was removed in v3.0.0 with the meta-standard's v1.2.0 (UR-0046): every item is born proposed and counts only once a person signs it. Who proposed an item is its origin attribute (human, ai, hybrid), not its status."

# 5. New link declaration. Made with tl apply so it is born with both its from and its via
#    link: tl 6.1.0 cannot load a graph holding a half-made link declaration while a
#    coverage rule names a link type, so tl new followed by tl link fails here.
out=$(tl apply - <<'JSON'
{"change_set_format": 2, "operations": [
 {"op": "new", "register": "LINK", "type": "link",
  "title": "A slide derives from claims of a graph the series composes",
  "text": "A slide derives from claims of a graph the series composes.",
  "rationale": "Lets a slide show a knowledge graph's claim instead of a copy, so a deck and a document derived from one knowledge graph share each claim (knowledge INT-0001).",
  "attrs": {"outside": true},
  "links": [{"target": "REG-0008", "type": "from"}, {"target": "meta:LT-0001", "type": "via"}]}
]}
JSON
)
echo "$out"
grep -q 'LINK-0011' <<<"$out" || { echo "STOP: expected tl to create LINK-0011" >&2; exit 1; }

# 6. Claims and sources become optional registers (amends two ratified items: they go ratified-stale)
tl amend REG-0010 --attr "required=false" --rationale "A claim is one statement a slide makes, resting on a source, and what kind of statement it is. Optional from v3.0.0: a series built from a knowledge graph shows that graph's claims (LINK-0011) and holds none of its own."
tl amend REG-0009 --attr "required=false" --rationale "A source is one document a claim rests on: where it is, who published it, when it was published and when it was last checked. A source may stand on its own. Optional from v3.0.0: a series built from a knowledge graph takes its sources from that graph."

tl check || true
