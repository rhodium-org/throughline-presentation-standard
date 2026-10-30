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

A series graph names this repository as its schema source and declares only what
it adds:

```toml
[[sources]]
namespace = "presentation"
url = "https://github.com/rhodium-org/throughline-presentation-standard"
ref = "v1.0.0"
schema = true
```

The series is then checked by this standard's item types, attributes, link types,
statuses, transitions, roles, grounding and coverage rules, plus its own additions.
It may add an attribute, a type, a status or a link type, but never redefine one
declared here. `tl migrate` removes a copy the standard makes redundant. This needs
throughline 4.4.0 or later.

Everything in this graph's `throughline.toml` is inherited, including the types
the standard uses for its own items (intent, constraint, rule, example, non-goal).
They are inert in a series that holds none.

## What is in this graph

| Register | Holds |
|---|---|
| `vision/` (INT) | why the standard exists |
| `constraints/` (CON) | obligations on the standard itself |
| `rules/` (RULE) | what a conforming series must do or may hold; every declaration in `throughline.toml` names its rule |
| `examples/` (EX) | the example series graphs in `conformance/`, and the rules each verifies |
| `non-goals/` (NG) | what the standard leaves out on purpose |

## Editions

The standard is released as tagged editions that a series pins. A change that
would make a conforming series fail is a new major edition, and its notes say what
a series must change.
