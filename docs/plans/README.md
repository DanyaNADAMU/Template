# Active Development Plans & Checklists

This directory stores active development roadmaps, milestone task checklists, and implementation trajectories.

## Standards
* **Actionable Checklists**: Use markdown checkboxes (`- [ ]`, `- [x]`) for tracking granular progress.
* **Session Startup**: Agents check this directory on session startup to understand current momentum and next steps.
* **Retirement**: Once a plan is 100% complete, it can be marked as completed or archived into `docs/plans/archive/`.
* **Required Metadata**: Every plan starts with `Status: Active|Paused|Done` and `Last touched: YYYY-MM-DD` directly below its title. `Last touched` records meaningful plan progress, not the date of a metadata-only retrofit.
* **Central Index**: The private `Index` repository generates a cross-project view from these fields and the first unchecked checklist item. Source plans remain authoritative; regenerate the index after a meaningful status or checklist change.
