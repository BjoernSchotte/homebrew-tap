require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260826032808.47.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260826.47.1-cb981dea/atlcli-darwin-arm64.tar.gz"
      sha256 "6870fdfc2a87b8a2077f2a0bc6f93ee7a18a1dfd0a34070c251168c8072c682e"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260826.47.1-cb981dea/atlcli-darwin-x64.tar.gz"
      sha256 "dbdf709abba94136048059d9a00e0b76b35a4cf6990414be2a2840eb975538a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260826.47.1-cb981dea/atlcli-linux-arm64.tar.gz"
      sha256 "00296ddd404e7aa3e8f005dfc4ecd11392b870df09f272a63ce773daa5359303"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260826.47.1-cb981dea/atlcli-linux-x64.tar.gz"
      sha256 "9141a19ccd7406a8a17c164e2d03f25b742b1de2e66613bbb36216db1b763004"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260826.47.1-cb981dea", info.fetch("releaseTag")
    assert_equal "cb981dea1f83d4dd5e17932239e42f99a1a607c7", info.fetch("sourceSha")
    assert_equal "20260826032808.47.1", info.fetch("homebrewVersion")
  end
end
