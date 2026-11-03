# Presentation format standard

A [throughline](https://github.com/rhodium-org/throughline) graph that states the
model a presentation series is written in: the kinds of item a series holds
(series, edition, thread, slide, source, claim, topic, interest, role), their
attributes and kinds, the links between them, and their lifecycle.

It is a standard, not a service and not content. It holds no series and no deck,
and says nothing about how a deck looks: brand, palette, fonts and slide styles
belong to whoever renders the deck, so one series can be rebranded for another
audience without touching its content.

## Following the standard

A series graph names this repository as its schema source:

```toml
[[sources]]
namespace = "presentation"
url = "https://github.com/rhodium-org/throughline-presentation-standard"
ref = "v2.2.0"
schema = true
```

The series is then checked against this standard's declarations: the registers,
attributes, links and link types it declares as items, plus the statuses,
transitions, grounding and coverage rules in its `throughline.toml`. Anything a
series holds that no declaration names is an error. A series may declare its own
additions (`scope = "this-graph"`), but never redefine one declared here. This needs
throughline 4.6.2 or later, and `tl init --from-schema` creates every register
declared here.

`follower/AGENTS.md` is written for the AI agents that write a series: how to work
through `tl`, what presentation-manager checks beyond these declarations, and how
slide text is written. Copy it into a new series as `AGENTS.md`, from the version
the series names; once throughline implements SR-0306, `tl init --from-schema` does
that for you.

## What is in this graph

| Register | Holds |
|---|---|
| `vision/` (INT) | why the standard exists |
| `registers/` (REG) | the registers a series holds (SER, one or more; ED, THR, SLD, SRC, CLM, TOP, AUD; ROLE when it has roles), and this graph's own |
| `types/` (TYPE), `enums/` (ENUM) | text, paragraphs, date, whole number, and the value sets |
| `attributes/` (ATTR) | each register's attributes, required or not, signed or not |
| `links/` (LINK), `link-types/` (LT) | which registers each link joins |
| `constraints/` (CON) | obligations on the standard itself |
| `rules/` (RULE) | the prose each declaration takes as its rationale |
| `examples/` (EX) | the example series graphs in `conformance/`, and the rules each verifies |
| `non-goals/` (NG) | what the standard leaves out on purpose |

The standard follows the throughline meta-standard
([throughline-standard-standard](https://github.com/rhodium-org/throughline-standard-standard)),
which fixes what a declaration is. The prose registers (CON, RULE, EX, NG) are on
their way out: a standard holds only declarations. Once every rule lives on as the
rationale of a declaration, or of the configuration it explains, the four registers go.

## Editions

The standard is released as tagged editions that a series pins. A change that
would make a conforming series fail is a new major edition, and its notes say what
a series must change.
