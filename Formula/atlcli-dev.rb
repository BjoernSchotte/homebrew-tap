require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260813122134.31.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.31.1-4b05fe47/atlcli-darwin-arm64.tar.gz"
      sha256 "e32eb91ed54e5c2048edf26c10cd34c54c239aadfb59a51a6d5e4994ecf9be3c"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.31.1-4b05fe47/atlcli-darwin-x64.tar.gz"
      sha256 "db3a3fae89f5443e606d8c641173a7b1448d96b6e4c56c3bc2168661478f6d28"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.31.1-4b05fe47/atlcli-linux-arm64.tar.gz"
      sha256 "9cbc57bbec770c470d33141ef528337eba723d0ad1c13d0ca46a2552e5196846"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.31.1-4b05fe47/atlcli-linux-x64.tar.gz"
      sha256 "c72a603d57f88d1ecabe1d5fc66ec8ee6f649042c8ba3d787bbc907deb4b0608"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260813.31.1-4b05fe47", info.fetch("releaseTag")
    assert_equal "4b05fe4787997c50e8e1a4307fa928d360d8612b", info.fetch("sourceSha")
    assert_equal "20260813122134.31.1", info.fetch("homebrewVersion")
  end
end
