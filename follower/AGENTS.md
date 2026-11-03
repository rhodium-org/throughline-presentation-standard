# Writing a presentation series

This folder is a throughline graph that follows the
[presentation format standard](https://github.com/rhodium-org/throughline-presentation-standard).
It is the standard's `follower/AGENTS.md`, from the version of the standard the graph names in
`throughline.toml`. It is yours now: add to it, but when you move the graph to a newer version of the
standard, compare it with that version's `follower/AGENTS.md`.

## Work through tl

- Run `tl context` first. It lists every kind of item, its fields, which are required and the links it
  may hold, generated from the standard at the pinned version.
- Change the graph only with `tl new`, `tl amend`, `tl link` and `tl delete`. Never edit the `.yml`
  files by hand.
- Finish every change with `tl check`. It must end with "graph is sound".
- Never declare in `throughline.toml` an attribute or type the standard declares; tl refuses it.
- Keep `ref` in `throughline.toml` at a tag of the standard, never `main`.
- Your items are `origin: ai` and stay `proposed` until a person signs them. Do not sign them yourself.

[standards.iddn.uk](https://standards.iddn.uk/#/g/rhodium-org/throughline-presentation-standard/main)
explains the standard: Explain lists what each item holds, Brief gives the same in the tools' terms.

## How a series is built

| Item | Prefix | Holds | Grounds on |
|---|---|---|---|
| Series | SER | name, audience, cover, `slug`, `kind`, `approval` | (a root) |
| Interest | AUD | what the audience wants to know | the series |
| Topic | TOP | what a thread is about | (a root) |
| Edition | ED | one deck: subject, presenter, dates, notes | the series |
| Thread | THR | a section, in `order`, with its `tone` | its edition and an interest; relates to a topic |
| Source | SRC | where a fact comes from, and when it was checked | (a root) |
| Claim | CLM | one statement, with its `role` | its sources |
| Slide | SLD | `order`, `layout`, the words | its thread, and the claims it states |

## What presentation-manager checks beyond the standard

presentation-manager builds decks from graphs that follow this standard. Before it builds, it checks
each edition. These checks are not in `tl check`, so meet them before you push: a failed build is
slow to come back.

**Every series**

- The series `slug` must be exactly the short name the deck is added under in presentation-manager.
- `cover_mark` names a square PNG in the graph, usually `assets/mark.png`: white on a transparent ground.
- With `approval: none`, a deck is published as soon as it is pushed; with `person`, only once a person
  has signed every item it shows. The series item itself is always signed by a person before any
  deck is published, and again after any change to it.

**Every slide**

- Has `layout` and `order`.
- A slide that states a number shows a claim: it derives from a claim that states it.

**A briefing series** (`kind: briefing`)

- An edition has `month`, `presenter` and `presented`, and, when `basis: graph`, both `news_from` and
  `news_to`, with no gap after the previous edition's window.
- At most 8 slides.
- Each thread derives from an interest of the series, relates to a topic, and holds at least one claim
  with `role: news`. Claims are `news` or `background`, and each rests on a source.
- A source has `url`, `publisher`, `published`, `checked` and `found_via`, is recorded against its
  original publisher, and was checked inside the window. A news claim rests on a source published in
  the window.

**A training series** (`kind: training`)

- The series has `max_slides` and `review_days`; a deck holds at most `max_slides` slides.
- A deck has `subject`, `subject_kind` (`role`, `product` or `common`), `revision` and `checked`, and
  no `month` or news window. A role deck derives from exactly one role. No two decks share a subject.
- Every interest of the series has a thread in the deck.
- Claims are `guidance` or `product`. A `product` claim names its `product` and rests on a source whose
  `official_for` is that product.
- A source has `url`, `publisher`, `checked` and `found_via`, and was checked no later than the deck's
  `checked` and no more than `review_days` before it.
- A deck may take a thread written for another deck of the series with an `includes` link.

## Slide text

A slide's title is its title. Its text is lines of `key: value`, then item lines that start `- ` with
fields separated by ` | `. `notes:` is the speaker notes on every layout, `narration:` what the
narrated video says instead.

| Layout | Keys (required in bold) | Item lines |
|---|---|---|
| `cards` | **eyebrow**, bar | 3 or 4 of `heading \| body` |
| `stats` | **eyebrow**, bar | 2 to 4 of `figure \| body` or `figure \| heading \| body` |
| `rows` | **eyebrow** | 2 to 5 of `heading \| body` |
| `definition` | **eyebrow**, **term**, **lead**, **body**, **label**, **listlead**, **bar** | 1 to 3 bullets |
| `compare` | **eyebrow**, **left**, **right**, bar | 1 to 3 each of `L \| text` and `R \| text` (1 to 4 without a bar) |
| `takeaway` | **accent**, **body** | none |
| `screenshot` | **eyebrow**, **image**, **alt**, caption | none |
| `video` | **eyebrow**, **video**, **poster**, **alt**, caption | none |

- `image` is a PNG or JPEG in the graph; `video` an MP4 with a PNG or JPEG `poster`. Keep them in `assets/`.
- An item line may start with a tone, `[red]`, `[green]`, `[teal]`, `[purple]` or `[magenta]`.
- On `cards`, `stats`, `rows` and `compare` it may then name an icon: `- {lightbulb} Heading | body`.
  The icons: book-open, bot, brain, calendar, chart-column, circle-check, clock, file-text, globe, key,
  layers, lightbulb, list-checks, lock, mail, message-circle, pen-line, presentation, puzzle, rocket,
  scale, search, shield, sparkles, star, table, target, triangle-alert, users, workflow.
- A body quoted whole, `"..."`, is drawn as a prompt box.
- The series' `slide_styles`, one to a line, chooses the look: `plain`, or `panels`, which animates every
  slide. The series' or edition's `motif` names a picture, or a folder of PNG, JPEG or animated GIF
  frames, drawn on the section dividers.

```
eyebrow: The evidence
bar: The gap between felt and measured is the lesson.
- +20% | Felt | How much faster they believed they had been.
- [red] -19% | Measured | They took longer.
```
