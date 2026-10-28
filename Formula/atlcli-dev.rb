require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261028084112.111.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261028.111.1-60af8e30/atlcli-darwin-arm64.tar.gz"
      sha256 "81a9c4bb6a091867e3020c17b746ca54f16e080bd07b6f21e76db66ecc3719ba"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261028.111.1-60af8e30/atlcli-darwin-x64.tar.gz"
      sha256 "2d157ae0021dd18f59f55cdfa7622a7d1b1fe4d434d16c8c7398ba267e049f6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261028.111.1-60af8e30/atlcli-linux-arm64.tar.gz"
      sha256 "c5b06917bb0fd814b6d4f4b47195915217d27df2e62584c8ce2e8cb221f93c9f"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261028.111.1-60af8e30/atlcli-linux-x64.tar.gz"
      sha256 "9dd7277445ebca18fc189cf4ba81824995ae926d1305ae87205ab9491f773081"
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
    assert_equal "dev-20261028.111.1-60af8e30", info.fetch("releaseTag")
    assert_equal "60af8e3041f239b173f4b25e8eab9e2eab03e4c5", info.fetch("sourceSha")
    assert_equal "20261028084112.111.1", info.fetch("homebrewVersion")
  end
end
