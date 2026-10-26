require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261026075252.109.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261026.109.1-f62566d0/atlcli-darwin-arm64.tar.gz"
      sha256 "20840bc983063240f0e1aaebe1eeb579fc1cd81b718054c3ae9710b6dc543784"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261026.109.1-f62566d0/atlcli-darwin-x64.tar.gz"
      sha256 "33bd5bde5b539685fe7d2664772435773a44b521b4f4425863f3e51f3e769a6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261026.109.1-f62566d0/atlcli-linux-arm64.tar.gz"
      sha256 "dc604df3ca0a312b9718874b1e5ae8619019b67581ea84f2e530dab9dafbc9b4"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261026.109.1-f62566d0/atlcli-linux-x64.tar.gz"
      sha256 "134ef24dce1efd92fd0d851d20044e12000073490c7670b0b18d373f3f770f39"
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
    assert_equal "dev-20261026.109.1-f62566d0", info.fetch("releaseTag")
    assert_equal "f62566d0760fd381af1b9737520878d9b93b8096", info.fetch("sourceSha")
    assert_equal "20261026075252.109.1", info.fetch("homebrewVersion")
  end
end
