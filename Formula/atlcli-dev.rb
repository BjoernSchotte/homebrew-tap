require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260825031435.46.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260825.46.1-6c6a1be9/atlcli-darwin-arm64.tar.gz"
      sha256 "46e165923f8c55890dcea6928cdbd058170c29dfe15cb6f8ed2bab83c82a3df1"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260825.46.1-6c6a1be9/atlcli-darwin-x64.tar.gz"
      sha256 "555a6a4c28627d0682e432d10915d3b3e3b168bb20d78c0c8c0d86b49c5cb9f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260825.46.1-6c6a1be9/atlcli-linux-arm64.tar.gz"
      sha256 "442abe9eb051ebe442f21a9eeb0bbe7b0742c8fe56e23d24da43ce1b69b322ee"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260825.46.1-6c6a1be9/atlcli-linux-x64.tar.gz"
      sha256 "2220c9c713bb9374a4c6f3ded76bdc4a13473b6ece2712666d1dcea5fa105965"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260825.46.1-6c6a1be9", info.fetch("releaseTag")
    assert_equal "6c6a1be95da7aafeb22542abc47eeb8fe490224b", info.fetch("sourceSha")
    assert_equal "20260825031435.46.1", info.fetch("homebrewVersion")
  end
end
