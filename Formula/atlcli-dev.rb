require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260813112110.28.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.28.1-8bea69a6/atlcli-darwin-arm64.tar.gz"
      sha256 "c4f6c02de27762290e09617ce7fe64b884068f64bd188c9c8333682849408801"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.28.1-8bea69a6/atlcli-darwin-x64.tar.gz"
      sha256 "5128ddd06106aa02f331473f12994c902a47d6490b7aec71cdc9a22596695462"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.28.1-8bea69a6/atlcli-linux-arm64.tar.gz"
      sha256 "73c45de78a86eab10eefe4f62c08fb5e3f16a35322cc30d8f49c0f9be874a249"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.28.1-8bea69a6/atlcli-linux-x64.tar.gz"
      sha256 "380f4bdea6995c922c4d4bcb5216e009337e9a6cbfab07f0a305ec99b9217f6d"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260813.28.1-8bea69a6", info.fetch("releaseTag")
    assert_equal "8bea69a68358621bb0503d7032289f4b4e23554e", info.fetch("sourceSha")
    assert_equal "20260813112110.28.1", info.fetch("homebrewVersion")
  end
end
