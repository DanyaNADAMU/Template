# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Workflow skeletons build images through the shared
  `Workflows/container-build.yml` catalog (lowercase GHCR name, layer
  cache, provenance + SBOM, Trivy severity gate) and gate releases
  through `Workflows/release-precheck.yml` (strict SemVer, CHANGELOG
  section, SSH tag-signature verification, ancestry from `main`).
- Skeletons now call for a `test`/`lint` job ahead of the build job and
  carry concurrency groups, `ubuntu-24.04` runners, and SHA-pinned
  actions; the `ots-cron.yml` stub grants `contents: write` explicitly.

## [v1.0.0] - 2026-11-09

### Added
- Standard project baseline with OpenTimestamps cryptographic anchoring.
- Dual-language living documentation structure (`docs/architecture/`, `docs/adr/`, `docs/plans/`, `docs/ru/`, `docs/en/`).
- Automated Bitcoin timestamping workflow in `.github/workflows/ots-cron.yml`.
- Standard versioned Git hooks in `.githooks/`.
- Release gate verification toolchain (`scripts/release-check.sh`, `scripts/release.sh`).
