require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20261022074143.105.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261022.105.1-fe2c9619/atlcli-darwin-arm64.tar.gz"
      sha256 "eb183e5b706700bd97dc152c4a82ff1062781eff4ef0fa24cf1dba3f8adc83f9"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261022.105.1-fe2c9619/atlcli-darwin-x64.tar.gz"
      sha256 "d59b531338ae105dbdeb1ca69076ceb5f383b6cf4cea15cfc7c993bc345aded2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261022.105.1-fe2c9619/atlcli-linux-arm64.tar.gz"
      sha256 "6500189fffb5b3c7c7534d441666ac1ed6e55db3e683b77854d3f4b60d849e04"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20261022.105.1-fe2c9619/atlcli-linux-x64.tar.gz"
      sha256 "2493cda1ad6c539a7874548e1aefe6469dc5796bb996b6ff914ee0a19478f07b"
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
    assert_equal "dev-20261022.105.1-fe2c9619", info.fetch("releaseTag")
    assert_equal "fe2c96194c383e41ecc4cd3432f826cb19cd02d7", info.fetch("sourceSha")
    assert_equal "20261022074143.105.1", info.fetch("homebrewVersion")
  end
end
