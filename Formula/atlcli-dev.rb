require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260813113127.29.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.29.1-f341b388/atlcli-darwin-arm64.tar.gz"
      sha256 "5963687d00b3e236c21187fbeb6495b8ab216922c52645d4ac7c466a89531cb9"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.29.1-f341b388/atlcli-darwin-x64.tar.gz"
      sha256 "30d1500484fbddf0f0fbbb0fb58daa0980ac79274c636c9fc7ac163a57c24842"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.29.1-f341b388/atlcli-linux-arm64.tar.gz"
      sha256 "79708adecc695123f3c26136c6dc3ecd70817033b79a81f253be87da7602d7ab"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.29.1-f341b388/atlcli-linux-x64.tar.gz"
      sha256 "e2b6307be1a9da23aee2389fee50171047eb1930f2904bb404e0e180a904c538"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260813.29.1-f341b388", info.fetch("releaseTag")
    assert_equal "f341b388a5b8226e748c17a303dd47e20dd65964", info.fetch("sourceSha")
    assert_equal "20260813113127.29.1", info.fetch("homebrewVersion")
  end
end
