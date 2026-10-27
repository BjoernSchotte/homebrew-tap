require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261027075841.110.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261027.110.1-d3a32830/atlcli-darwin-arm64.tar.gz"
      sha256 "f06630cfe46ba1f47220d60de854ccd1a9de89ad46e892a0aba0c26016e4ee94"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261027.110.1-d3a32830/atlcli-darwin-x64.tar.gz"
      sha256 "02b6f3fa0295844094009aa5cedfae064fd9c0f03e1f13a81f2fc9fb39207108"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261027.110.1-d3a32830/atlcli-linux-arm64.tar.gz"
      sha256 "bb62982c224493074fcac91ad15c3bfe1d9f3edeb4a14e032a79256ba2c57027"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261027.110.1-d3a32830/atlcli-linux-x64.tar.gz"
      sha256 "6b68129ab78eb6c7b30225ad7ba0382e3c0677e874da4258445a6b099f1c00fb"
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
    assert_equal "dev-20261027.110.1-d3a32830", info.fetch("releaseTag")
    assert_equal "d3a328303f20ba32be11115532ef20bf78c8806a", info.fetch("sourceSha")
    assert_equal "20261027075841.110.1", info.fetch("homebrewVersion")
  end
end
