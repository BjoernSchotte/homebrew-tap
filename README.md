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

## Updating

After a new release, run the "Update Formula" workflow from the Actions tab.
The separate "Update Dev Formula" workflow accepts only a complete immutable
dev release and commits after native Linux and macOS install tests pass.
