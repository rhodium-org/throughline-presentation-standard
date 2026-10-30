# Conformance examples

Each directory here is a small example series graph that names this standard as
its schema source. An `EX` item in `../examples/` describes each one and verifies
the rules it shows: a conforming example must pass `tl check`, and a deliberately
broken one must fail it for the reason its item states.

`check.sh` runs every example and is a step of CI's `graph` job.
