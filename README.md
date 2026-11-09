# Standard Project Baseline Template

This repository represents the canonical baseline structure for all projects.

## Project Structure
- `.githooks/` - Versioned Git hooks for invisible OpenTimestamps background anchoring and security validations.
- `.github/workflows/ots-cron.yml` - Daily automated proof upgrading & verification via GitHub Actions.
- `.allowed_signers` - Trusted public keys for commit and tag cryptographic verification.
- `SECURITY.md` - Security policy and trust anchoring.
- `CHANGELOG.md` - Structured release notes adhering to Keep a Changelog and Semantic Versioning.
- `docs/` - Living documentation (Architecture, ADR, Plans, Ideas, User Guides in `ru/` and `en/`).
- `scripts/`
  - `retrofit.sh` - Helper script to upgrade existing repositories to this baseline.
  - `release.sh` - Milestone release creation tool (changelog bump, signed tag, OpenTimestamps sync).
  - `release-check.sh` - Universal release gate verifier (clean tree, main branch, SemVer tag, changelog entry).

## Quickstart for New Projects
1. Copy or clone this template:
   ```bash
   cp -r /Projects/Template /Projects/<ProjectName>
   cd /Projects/<ProjectName>
   git init
   git config core.hooksPath .githooks
   ```
2. Create and test features in short-lived branches (`feat/<topic>`).
3. Merge into `main` after staging validation.
4. Cut a milestone release:
   ```bash
   scripts/release.sh v1.0.0
   ```
