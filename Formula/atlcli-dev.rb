require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260813110455.26.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.26.1-8bea69a6/atlcli-darwin-arm64.tar.gz"
      sha256 "f145ee2a21f7277a81e46b0908be84397ed97c8cb12772ee51cf73be8c11d0fa"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.26.1-8bea69a6/atlcli-darwin-x64.tar.gz"
      sha256 "91c1edc1df32ab0026f9b095742f78a43b0ae7212d0be40e38b08a95081dee7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.26.1-8bea69a6/atlcli-linux-arm64.tar.gz"
      sha256 "663656c638fd983c0b062da3b56074152dc846620211bbf37fa004af5582e02f"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.26.1-8bea69a6/atlcli-linux-x64.tar.gz"
      sha256 "d3f2baa97412d966860e6d6cfbb9eb8cee16ad18e155436391de59c71878ac9c"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260813.26.1-8bea69a6", info.fetch("releaseTag")
    assert_equal "8bea69a68358621bb0503d7032289f4b4e23554e", info.fetch("sourceSha")
    assert_equal "20260813110455.26.1", info.fetch("homebrewVersion")
  end
end
