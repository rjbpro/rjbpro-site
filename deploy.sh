#!/usr/bin/env bash
# RJB Contracting — publish / update the live site
# ----------------------------------------------------
# Usage (from the "Creating Website" folder, in Terminal):
#     bash deploy.sh
#   or with your own note:
#     bash deploy.sh "Added new team photos"
#
# This commits everything and pushes to GitHub. If GitHub Pages is
# enabled (one-time setup, see PUBLISH.md), your live site updates
# automatically a minute or two later.

set -e
cd "$(dirname "$0")"

# Clear any stale lock left by an interrupted git run
rm -f ".git/index.lock" 2>/dev/null || true

echo "→ Staging all changes..."
git add -A

if git diff --cached --quiet; then
  echo "→ No new changes to commit. Pushing existing commits (if any)."
else
  MSG="${1:-Update site $(date '+%Y-%m-%d %H:%M')}"
  git commit -m "$MSG"
  echo "→ Committed: $MSG"
fi

echo "→ Pushing to GitHub (origin/main)..."
git push origin main

echo ""
echo "✅ Pushed. GitHub Pages rebuilds in ~1–2 minutes."
echo "   Live site: https://rjbpro.github.io/rjbpro-site/"
