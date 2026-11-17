#!/usr/bin/env bash
set -euo pipefail

formula="${1:?Formula name is required}"
version="${2:?Release tag is required}"
tap="${TAP_NAME:?Tap name is required}"

if ! [[ "$formula" =~ ^[a-z0-9][a-z0-9+@._-]*$ ]] || [ ! -f "Formula/$formula.rb" ]; then
  echo "Unknown formula: $formula" >&2
  exit 1
fi

if ! [[ "$version" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Expected a stable release tag such as v1.9.1: $version" >&2
  exit 1
fi

tap_directory="$(brew --repository "$tap")"
if [ ! -d "$tap_directory" ]; then
  brew tap "$tap" "$PWD"
fi
# Homebrew's updater requires a GitHub remote, even in write-only mode.
git -C "$tap_directory" remote set-url origin "$(git remote get-url origin)"
cp "Formula/$formula.rb" "$tap_directory/Formula/$formula.rb"
brew trust "$tap"

formula_info="$(brew info --json=v2 "$tap/$formula")"
source_repo="$(brew ruby -- -rjson -e '
  url = JSON.parse(STDIN.read).fetch("formulae").fetch(0).fetch("urls").fetch("stable").fetch("url")
  match = %r{\Ahttps://github\.com/([^/]+/[^/]+)/}.match(url)
  abort "Automatic updates require a GitHub source URL in the existing formula" unless match
  puts match[1]
' <<< "$formula_info")"
current_version="$(brew ruby -- -rjson -e '
  puts JSON.parse(STDIN.read).fetch("formulae").fetch(0).fetch("versions").fetch("stable")
' <<< "$formula_info")"

echo "Checking $source_repo release $version for $formula (currently $current_version)"
release_tag="$(gh api "repos/$source_repo/releases/tags/$version" \
  --jq 'select(.draft == false and .prerelease == false) | .tag_name')"
if [ "$release_tag" != "$version" ]; then
  echo "Release $version must be published and stable" >&2
  exit 1
fi

target_version="${version#v}"
brew ruby -- -rrubygems -e '
  abort "Refusing to downgrade #{ARGV[0]} to #{ARGV[1]}" if Gem::Version.new(ARGV[1]) < Gem::Version.new(ARGV[0])
' "$current_version" "$target_version"

if [ "$current_version" = "$target_version" ]; then
  echo "$formula is already at $version"
  exit 0
fi

brew bump-formula-pr --write-only --no-audit --no-browse \
  --version="$target_version" "$tap/$formula"
cp "$tap_directory/Formula/$formula.rb" "Formula/$formula.rb"
echo "Prepared $formula $version"
