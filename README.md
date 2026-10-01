# Homebrew Tap

Homebrew formulae for tools by Björn Schotte.

## Installation

```bash
brew tap bjoernschotte/tap
brew install atlcli
```

Or directly:

```bash
brew install bjoernschotte/tap/atlcli
```

Development builds are published from a green `main` commit as immutable
prereleases. They deliberately conflict with the stable formula because both
install the `atlcli` executable:

```bash
brew uninstall atlcli
brew install bjoernschotte/tap/atlcli-dev
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| [atlcli](https://github.com/bjoernschotte/atlcli) | CLI for Atlassian Confluence and Jira |
| [atlcli-dev](https://github.com/bjoernschotte/atlcli/releases) | Verified development channel from `main` |
| [agentglass](https://github.com/BjoernSchotte/agentglass) | See every coding agent on your machine — live |
| [agentglass-dev](https://github.com/BjoernSchotte/agentglass/releases) | Daily development build of agentglass `main` |

### agentglass

```bash
brew install bjoernschotte/tap/agentglass       # stable
brew install bjoernschotte/tap/agentglass-dev   # daily dev build (conflicts with stable)
```

Current Homebrew resolves the dev formula's conflict with the stable one only for trusted taps:
run `brew trust bjoernschotte/tap` once (the same applies to `atlcli-dev`).

## Updating

After a new release, run the "Update Formula" workflow from the Actions tab.
The separate "Update Dev Formula" workflow accepts only a complete immutable
dev release and commits after native Linux and macOS install tests pass.
`agentglass` releases dispatch "Update Formula" (`formula=agentglass`) and "Update agentglass-dev" themselves.
