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


### Optional Confluence NFS companion

New Unix archives may include `atlcli-confluence-nfs`. Both channel formulas
install it beside `atlcli`, with its license notices and build manifest in
`pkgshare`. CLI-only archives remain supported. `brew test` checks the helper
without contacting Confluence when it is present. This supports the experimental
transport in [atlcli PR #203](https://github.com/BjoernSchotte/atlcli/pull/203).

Regression checks: `ruby -Itest test/dev_release_test.rb` and
`ruby -Itest test/workflow_policy_test.rb`. The installer test executes both
checked-in formula install methods and a newly rendered dev formula against
CLI-only and companion fixtures. Native isolated installations were also tested
on macOS arm64 and Linux x64 using local review archives; the Linux installed CLI
passed the four live DOCSY read-only mount lifecycle cases. No release was made.
