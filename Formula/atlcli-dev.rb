require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260813095527.25.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.25.1-f341b388/atlcli-darwin-arm64.tar.gz"
      sha256 "09d3dd6a205f36ca4171875f40658781e4b27fb7a87571c6c72b4df0f90e1588"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.25.1-f341b388/atlcli-darwin-x64.tar.gz"
      sha256 "692f41e86821088c4ac406e2376a675a3f0f9642c50f75ce3fdb130f92e8ea42"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.25.1-f341b388/atlcli-linux-arm64.tar.gz"
      sha256 "b8c88093947adafb75d8937b837cd728fdddbbff5f96700277d6bae70eef432a"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.25.1-f341b388/atlcli-linux-x64.tar.gz"
      sha256 "80dfb10a9009af10147e245caf0a59663915ead0904cd0deda255e2b7bfea349"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260813.25.1-f341b388", info.fetch("releaseTag")
    assert_equal "f341b388a5b8226e748c17a303dd47e20dd65964", info.fetch("sourceSha")
    assert_equal "20260813095527.25.1", info.fetch("homebrewVersion")
  end
end
