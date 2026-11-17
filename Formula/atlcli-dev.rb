require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261117104858.131.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261117.131.1-f784f5da/atlcli-darwin-arm64.tar.gz"
      sha256 "c4bae86cf020f1109afcc0862d780425486ade9f9ffffa4a87a892d1f200f0a0"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261117.131.1-f784f5da/atlcli-darwin-x64.tar.gz"
      sha256 "ace4d730d05752909e8d975953dbf94e80d4e78239ff47706b65cca1a8ded804"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261117.131.1-f784f5da/atlcli-linux-arm64.tar.gz"
      sha256 "15d476b9a805d712c35daf671ceac49b20207375147010f81b7fc0d126422da6"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261117.131.1-f784f5da/atlcli-linux-x64.tar.gz"
      sha256 "c34a048adcf9e27fff47b8163fcfe35e7ac493c7c5cf93fa490400c6a48d5391"
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
    assert_equal "dev-20261117.131.1-f784f5da", info.fetch("releaseTag")
    assert_equal "f784f5dad45b9548d4a6143d3731e04a173a9330", info.fetch("sourceSha")
    assert_equal "20261117104858.131.1", info.fetch("homebrewVersion")
  end
end
