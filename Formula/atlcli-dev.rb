require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260819031317.40.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260819.40.1-cec8aac6/atlcli-darwin-arm64.tar.gz"
      sha256 "21ff072bccc32fe680035cf6fc10ebbd154b04040116995a7962e79ce3362348"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260819.40.1-cec8aac6/atlcli-darwin-x64.tar.gz"
      sha256 "425daabe59fb368053b574a2ebe826e1328f1e1e1fabdfcd9605bbd9da8f906c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260819.40.1-cec8aac6/atlcli-linux-arm64.tar.gz"
      sha256 "b63144e070b26a55c5f0f453b90050455cf3320f0a0cf1a70f38701596f3fefe"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260819.40.1-cec8aac6/atlcli-linux-x64.tar.gz"
      sha256 "ccdec1e95f08c9085e9b94454ef955432ac5c237da85d5e73875ab4ba10800b2"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260819.40.1-cec8aac6", info.fetch("releaseTag")
    assert_equal "cec8aac644beb6918b77a7fdbd18513e4ae22ccd", info.fetch("sourceSha")
    assert_equal "20260819031317.40.1", info.fetch("homebrewVersion")
  end
end
