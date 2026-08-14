require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260814024231.34.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260814.34.1-e439c62f/atlcli-darwin-arm64.tar.gz"
      sha256 "e8a8f5eb2c3d1ed334bdd91a988c8e1ec6df10d5cf3ed2524f81d6b7988b39af"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260814.34.1-e439c62f/atlcli-darwin-x64.tar.gz"
      sha256 "1554b437306b4297e82c1464507ddb21e70d57a17b7cf68392fe620ebb6e3750"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260814.34.1-e439c62f/atlcli-linux-arm64.tar.gz"
      sha256 "14eb07a7f1a13f5ccb6858f284ae278b7d78dc968030815b95f14ebae423ae52"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260814.34.1-e439c62f/atlcli-linux-x64.tar.gz"
      sha256 "9775bca477c12edfb90ea8a7c08246c428b7985142da71e793116cf00a0103df"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260814.34.1-e439c62f", info.fetch("releaseTag")
    assert_equal "e439c62f318bee363045ef8beab62800704213f0", info.fetch("sourceSha")
    assert_equal "20260814024231.34.1", info.fetch("homebrewVersion")
  end
end
