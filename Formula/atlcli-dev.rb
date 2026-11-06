require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261106093006.120.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261106.120.1-02da184f/atlcli-darwin-arm64.tar.gz"
      sha256 "120122d59ffdcd36eef328bd3ee2b48404ed782ebffb04a60a12eb961cf4750a"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261106.120.1-02da184f/atlcli-darwin-x64.tar.gz"
      sha256 "7599fe8a603674aecdc1f433dd7a176c67e92620c374c9af4b8337502e4aa290"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261106.120.1-02da184f/atlcli-linux-arm64.tar.gz"
      sha256 "a0222a5918152715ad91c6aea709776934d15423d3f21c026716ea11dcc6f2de"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261106.120.1-02da184f/atlcli-linux-x64.tar.gz"
      sha256 "61a64ca6ae04f6ad6e7f96f422f4b00cb00e69ea8594c767a248e77aebad9c5a"
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
    assert_equal "dev-20261106.120.1-02da184f", info.fetch("releaseTag")
    assert_equal "02da184f74394ca885aabb61f7bb3e6411bbde7d", info.fetch("sourceSha")
    assert_equal "20261106093006.120.1", info.fetch("homebrewVersion")
  end
end
