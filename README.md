# homebrew-tap

Personal Homebrew tap for packages published by AspireOne.

## Usage

On macOS or Linux, add and trust the tap once:

```sh
brew tap AspireOne/tap
brew trust AspireOne/tap
```

Then install any formula from this tap:

```sh
brew install <formula>
```

You can also trust the tap and install a formula directly without adding the tap first:

```sh
brew trust AspireOne/tap
brew install AspireOne/tap/<formula>
```

## Formulas

- `codex-manage`

For example:

```sh
brew install AspireOne/tap/codex-manage
```

## Updating formulas

This tap owns formula updates. Package release workflows send the existing formula name and a published stable release tag. The updater uses the formula's GitHub source URL to identify the upstream repository, then uses Homebrew's updater to change the version and checksum while preserving the rest of the formula.

The candidate must pass the same audits, source builds, and tests as regular CI on Linux before it reaches `main`. Repeating the current version succeeds without a commit; older versions and prereleases are rejected. Concurrent update requests queue. If `main` changes during validation, publishing fails rather than overwriting that change; rerun the update.

To request an update manually:

```sh
gh workflow run update-formula.yml \
  --repo AspireOne/homebrew-tap \
  -f formula=codex-manage \
  -f version=v1.9.1
```

Follow the result in [Update formula runs](https://github.com/AspireOne/homebrew-tap/actions/workflows/update-formula.yml).

### Connecting a package

Add and test its formula in this repository first. In the package repository, set `HOMEBREW_TAP_REPO` to `AspireOne/homebrew-tap` and add a `HOMEBREW_TAP_TOKEN` secret with **Contents: write** access to this tap. The token sends a repository dispatch event; it needs no Actions permission. The package's built-in `GITHUB_TOKEN` cannot access another repository.

Add this notification to the package's stable-release workflow, using its formula name:

```yaml
- name: Request Homebrew update
  if: github.event.release.prerelease == false
  env:
    GH_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
    TAP_REPO: ${{ vars.HOMEBREW_TAP_REPO }}
    VERSION: ${{ github.event.release.tag_name }}
  run: |
    gh api --method POST "repos/$TAP_REPO/dispatches" \
      -f event_type=update-formula \
      -f 'client_payload[formula]=codex-manage' \
      -f "client_payload[version]=$VERSION"
```

This example assumes a `release: published` event. A workflow that publishes releases itself should send its resolved release tag after publishing and skip prereleases. A successful notification means the request was accepted; validation and publishing run separately in this tap.
