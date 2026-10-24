require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261024072253.107.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261024.107.1-db121b0a/atlcli-darwin-arm64.tar.gz"
      sha256 "f92db762b2f051ab0136ec9c8914cd32c29cb9fc48ac31a4ae9488e94ab9c816"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261024.107.1-db121b0a/atlcli-darwin-x64.tar.gz"
      sha256 "52a52f0f5ef800487fc12bdb3b4cb436207e5b0f8a24c13cd02dda6152f19419"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261024.107.1-db121b0a/atlcli-linux-arm64.tar.gz"
      sha256 "4e67940c2e60c1aa15d376f92e9fc3111bb72661e7709205952d1a1825a6fe0b"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261024.107.1-db121b0a/atlcli-linux-x64.tar.gz"
      sha256 "db9829b0d5ec6cf0f2f378cb1e0f21de039278be00caa67fac1c9e620aff4b76"
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
    assert_equal "dev-20261024.107.1-db121b0a", info.fetch("releaseTag")
    assert_equal "db121b0ae2f131c34a82be87cb4dbe085e01a544", info.fetch("sourceSha")
    assert_equal "20261024072253.107.1", info.fetch("homebrewVersion")
  end
end
