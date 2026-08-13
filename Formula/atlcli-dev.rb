require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260813121124.30.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.30.1-f341b388/atlcli-darwin-arm64.tar.gz"
      sha256 "40c9fd6a9b6796446906377e7a65ae544351667f100f77c0024672979cb84eb5"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.30.1-f341b388/atlcli-darwin-x64.tar.gz"
      sha256 "f952658d38c49a9cfc09e47b1816a5b82be9e752288caef71eb416c885bcf79a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.30.1-f341b388/atlcli-linux-arm64.tar.gz"
      sha256 "128077368501f54fd2c404d1eeee6f626859a351cde5cc2e0cf5a2ef6d7fb91c"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.30.1-f341b388/atlcli-linux-x64.tar.gz"
      sha256 "081ddc57a24557881000092d554a2e9b887c50bf11480f45d943bdc9765dd16e"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260813.30.1-f341b388", info.fetch("releaseTag")
    assert_equal "f341b388a5b8226e748c17a303dd47e20dd65964", info.fetch("sourceSha")
    assert_equal "20260813121124.30.1", info.fetch("homebrewVersion")
  end
end
