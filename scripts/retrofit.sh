#!/bin/sh
set -e

TARGET="$1"

if [ -z "$TARGET" ] || [ ! -d "$TARGET/.git" ]; then
    echo "Usage: $0 /path/to/target/git-repo"
    exit 1
fi

TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Retrofitting $TARGET to standard baseline..."

# 1. Copy hooks
mkdir -p "$TARGET/.githooks"
cp "$TEMPLATE_DIR/.githooks/"* "$TARGET/.githooks/"
chmod +x "$TARGET/.githooks/"*

# 2. Copy CI workflows
# Container services take all three (build, release, ots-cron);
# non-container repositories (Keys, Infra) keep only ots-cron.yml.
mkdir -p "$TARGET/.github/workflows"
cp "$TEMPLATE_DIR/.github/workflows/ots-cron.yml" "$TARGET/.github/workflows/"
if [ -f "$TARGET/Containerfile" ] || [ -f "$TARGET/Dockerfile" ] || [ -d "$TARGET/container" ]; then
    cp "$TEMPLATE_DIR/.github/workflows/build.yml" "$TARGET/.github/workflows/"
    cp "$TEMPLATE_DIR/.github/workflows/release.yml" "$TARGET/.github/workflows/"
    echo "  [+] Added build/release/ots-cron workflows (container service)"
else
    echo "  [+] Added ots-cron workflow only (no container image)"
fi

# 3. Copy signers & security policy
cp "$TEMPLATE_DIR/.allowed_signers" "$TARGET/.allowed_signers"
[ ! -f "$TARGET/SECURITY.md" ] && cp "$TEMPLATE_DIR/SECURITY.md" "$TARGET/SECURITY.md"

# 4. Copy standard CHANGELOG.md if absent
if [ ! -f "$TARGET/CHANGELOG.md" ]; then
    cp "$TEMPLATE_DIR/CHANGELOG.md" "$TARGET/CHANGELOG.md"
    echo "  [+] Added initial CHANGELOG.md"
fi

# 5. Copy release automation & release gate check scripts
mkdir -p "$TARGET/scripts"
cp "$TEMPLATE_DIR/scripts/release-check.sh" "$TARGET/scripts/"
cp "$TEMPLATE_DIR/scripts/release.sh" "$TARGET/scripts/"
chmod +x "$TARGET/scripts/release-check.sh" "$TARGET/scripts/release.sh"

# 6. Configure Git hooks and signing
# Use the signing key from the active environment ($HOME), not a hardcoded
# root path — retrofit runs as a regular user on native workstations.
SIGNING_KEY="${HOME}/.ssh/danya-git.pub"
if [ ! -f "$SIGNING_KEY" ]; then
    echo "ERROR: signing key not found at $SIGNING_KEY" >&2
    echo "Provide the danya-git Ed25519 public key before retrofitting." >&2
    exit 1
fi
(
    cd "$TARGET"
    git config core.hooksPath .githooks
    git config commit.gpgsign true
    git config tag.gpgsign true
    git config gpg.format ssh
    git config user.signingkey "$SIGNING_KEY"
    git config gpg.ssh.allowedSignersFile .allowed_signers
)

# 7. Scaffold documentation layout
for dir in architecture adr plans ideas ru en; do
    mkdir -p "$TARGET/docs/$dir"
done
if [ ! -f "$TARGET/docs/adr/template.md" ]; then
    cp -r "$TEMPLATE_DIR/docs/" "$TARGET/"
fi

echo "==> Retrofit completed! Files added to $TARGET. Activate with a commit."
