require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261021074607.104.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261021.104.1-06588e35/atlcli-darwin-arm64.tar.gz"
      sha256 "5fdd7de85eb80d2b9bd98c82c89de32e01e991645af884592c7282efafff2938"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261021.104.1-06588e35/atlcli-darwin-x64.tar.gz"
      sha256 "5e4af9c83c5980017fabb1883f5545716f0b54000fc4eec71f8b9fed889dc925"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261021.104.1-06588e35/atlcli-linux-arm64.tar.gz"
      sha256 "e9fbf2e3e68abf11625c4e970eff666a639beb102ac6a397e1a2c2e31b106580"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261021.104.1-06588e35/atlcli-linux-x64.tar.gz"
      sha256 "0756cd7dbc18a7efd4f25c3f073f901c8c97be6ee48124258e8ebbbbae42d1c3"
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
    assert_equal "dev-20261021.104.1-06588e35", info.fetch("releaseTag")
    assert_equal "06588e35e27fbf67ef7bca5677b07af0b7a18b9f", info.fetch("sourceSha")
    assert_equal "20261021074607.104.1", info.fetch("homebrewVersion")
  end
end
