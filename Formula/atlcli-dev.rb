require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261109095430.123.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261109.123.1-b2039383/atlcli-darwin-arm64.tar.gz"
      sha256 "3b6cde212e7850aa13f840d6b1afd5cda4c2b0ba920aa292a9464da75a765a8a"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261109.123.1-b2039383/atlcli-darwin-x64.tar.gz"
      sha256 "36d3b6db111e3c6e191c1728c9726b8a7a45f161007e360cb117a59d4f33c800"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261109.123.1-b2039383/atlcli-linux-arm64.tar.gz"
      sha256 "c7dbd8e7bf9a8f24ace09c112ed5a85325e5bdbca7cbe22f1cc551d21065e7b6"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261109.123.1-b2039383/atlcli-linux-x64.tar.gz"
      sha256 "7a6f83368ec481214ff2de4272c1e948d2b2db1e7a9ac25be9d15dcec20bd2bf"
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
    assert_equal "dev-20261109.123.1-b2039383", info.fetch("releaseTag")
    assert_equal "b2039383bf3c99a2a9c516e230db6c482635fdd8", info.fetch("sourceSha")
    assert_equal "20261109095430.123.1", info.fetch("homebrewVersion")
  end
end
