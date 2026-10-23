require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261023073900.106.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261023.106.1-045d505f/atlcli-darwin-arm64.tar.gz"
      sha256 "0cbf34f0b86717b15817bb13280cd2a3b2db99e60c882e0119f00b217142fc2c"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261023.106.1-045d505f/atlcli-darwin-x64.tar.gz"
      sha256 "e5a2cbd1220d525f198457d7ace2f7b930e90924c8aaef65254106c0c47931b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261023.106.1-045d505f/atlcli-linux-arm64.tar.gz"
      sha256 "d96d4bfbef1cda1c58fc2f24852cdbbd87f09f2b1987a7d73736ea27b9924428"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261023.106.1-045d505f/atlcli-linux-x64.tar.gz"
      sha256 "fd3c9700388f4d2c1f35cead0fca856ea894ee87a4a1f2ebfd011c6e6f799405"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
    if File.exist?("atlcli-confluence-nfs")
      bin.install "atlcli-confluence-nfs"
      pkgshare.install "LICENSE-nfsserve", "THIRD-PARTY-nfs.html", "nfs-helper-build.json"
    end
  end

  test do
    if (bin/"atlcli-confluence-nfs").exist?
      assert_match "atlcli-confluence-nfs", shell_output("#{bin}/atlcli-confluence-nfs --version")
      assert_path_exists pkgshare/"THIRD-PARTY-nfs.html"
    end
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20261023.106.1-045d505f", info.fetch("releaseTag")
    assert_equal "045d505f00da0d0ec2f9a5aee6eec945ecb70036", info.fetch("sourceSha")
    assert_equal "20261023073900.106.1", info.fetch("homebrewVersion")
  end
end
