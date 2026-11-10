require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261110095813.124.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261110.124.1-d80901d9/atlcli-darwin-arm64.tar.gz"
      sha256 "b521ea2dd8f95d303f1f293c62fce261eee643354f93de510ab0474de72f473e"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261110.124.1-d80901d9/atlcli-darwin-x64.tar.gz"
      sha256 "e32652973d7135926d8183f02d82465e4cad5ad8d5848a8c5096e1a8da506ca4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261110.124.1-d80901d9/atlcli-linux-arm64.tar.gz"
      sha256 "68731a3dcabf2157438a83d5b2b5f3a60cd2e6bd86310a9a6366505c3aa319f0"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261110.124.1-d80901d9/atlcli-linux-x64.tar.gz"
      sha256 "e249b0c5f65c9646bb0e600db647c8d72eef7c1bf66a9a546325ade301ae39ce"
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
    assert_equal "dev-20261110.124.1-d80901d9", info.fetch("releaseTag")
    assert_equal "d80901d96172e4fe82490977b5d666ab1840bc9d", info.fetch("sourceSha")
    assert_equal "20261110095813.124.1", info.fetch("homebrewVersion")
  end
end
