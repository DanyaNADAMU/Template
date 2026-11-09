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

# 2. Copy CI workflow
mkdir -p "$TARGET/.github/workflows"
cp "$TEMPLATE_DIR/.github/workflows/ots-cron.yml" "$TARGET/.github/workflows/"

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
(
    cd "$TARGET"
    git config core.hooksPath .githooks
    git config commit.gpgsign true
    git config tag.gpgsign true
    git config gpg.format ssh
    git config user.signingkey /root/.ssh/danya-git.pub
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
