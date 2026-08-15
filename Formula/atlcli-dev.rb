require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260815030759.36.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260815.36.1-690a3974/atlcli-darwin-arm64.tar.gz"
      sha256 "b9b49e153ff1b820c546e2d5df95cf3f663b2ca36e37db969b4f23f1af1177f9"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260815.36.1-690a3974/atlcli-darwin-x64.tar.gz"
      sha256 "dff2245d1be7bfae60e3d1c4ead1ddb4d936f40338adbcc93a94ae47a95ea8cc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260815.36.1-690a3974/atlcli-linux-arm64.tar.gz"
      sha256 "31d7733bb402a9d1a47c6ded5a7eca251b9896d37522efa3d0738f0a174044de"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260815.36.1-690a3974/atlcli-linux-x64.tar.gz"
      sha256 "7ded2c6583621e87ae30d04fa00e09641aedada36150e36f3f41ef02554e0735"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260815.36.1-690a3974", info.fetch("releaseTag")
    assert_equal "690a39746373fe08159e1f1a36a118a3648837d8", info.fetch("sourceSha")
    assert_equal "20260815030759.36.1", info.fetch("homebrewVersion")
  end
end
