# <Project> — Project Agent Rules

Copy this file into the repo root on day one, fill in the sections, and keep
it current. It is the first thing every agent session reads (global ruleset
lives in `~/Projects/Agent/AGENTS.md` and applies on top of this file).

## What This Project Is

<!-- One paragraph: purpose, users, boundaries. -->

## Non-Negotiables

- **Global rules win**: `~/Projects/Agent/AGENTS.md` (auth delegation via
  Authentik, exactly one break-glass admin, core → CLI/TUI → GUI build order,
  secrets only in Infra vault, systemd over cron, ufw over raw iptables).
- **Secrets never live here**: this repo is public by default; real values go
  to the `Infra` vault, placeholders (`CHANGE_ME_*`) go into defaults.
- **Tested to main, tagged to prod**: all work validated on the `test` bed
  first; production deploys only via signed SemVer tags + CHANGELOG entry.

## Module Boundaries

<!-- List each module with a one-line contract; state which layer may never
import which (core never imports interfaces, etc.). -->

## Conventions

- Commits: Conventional Commits, English, SSH-signed (`danya-git`).
- Docs: bilingual `docs/en/` + `docs/ru/` for anything user-facing.
- Code: strict static typing, tests as specification for every non-trivial change.