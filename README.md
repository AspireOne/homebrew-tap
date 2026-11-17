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
