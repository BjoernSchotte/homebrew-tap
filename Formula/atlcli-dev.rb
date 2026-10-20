require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261020224028.103.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261020.103.1-b48d8474/atlcli-darwin-arm64.tar.gz"
      sha256 "877cc9ba6049e3e9d0129889a0be076b6cbbc90eaaa1e2cccbecd66c8ff56fe1"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261020.103.1-b48d8474/atlcli-darwin-x64.tar.gz"
      sha256 "ef9bddd3b5c5db01da971a9e0a4e9b5e436328e12be181a62deb72d10d56d6a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261020.103.1-b48d8474/atlcli-linux-arm64.tar.gz"
      sha256 "0f0d27cad105d5f482771d3f84d26dc1fe01694794555d131925b3cb0bd6e868"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261020.103.1-b48d8474/atlcli-linux-x64.tar.gz"
      sha256 "486189ea91104d2ac402c231a158d84e561d935d49005b355493a86924390c8d"
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
    assert_equal "dev-20261020.103.1-b48d8474", info.fetch("releaseTag")
    assert_equal "b48d8474c83e8afe580fd60832834afa3a1922f0", info.fetch("sourceSha")
    assert_equal "20261020224028.103.1", info.fetch("homebrewVersion")
  end
end
