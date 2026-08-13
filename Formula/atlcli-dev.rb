require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260813124329.32.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.32.1-18184731/atlcli-darwin-arm64.tar.gz"
      sha256 "3d9e5cea4347e23436caede7b0c5a96198fe1b3ff83f418069c86831bdde88c3"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.32.1-18184731/atlcli-darwin-x64.tar.gz"
      sha256 "2c7cc70aa897c1c5e823d4193eafc6f69130367d43475217c50938642f4ba994"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.32.1-18184731/atlcli-linux-arm64.tar.gz"
      sha256 "65c11a26e13209273a3cf064e917535c89164733152ec39d480d1b01da9abec9"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260813.32.1-18184731/atlcli-linux-x64.tar.gz"
      sha256 "3dd7aea094103dc35e2a7756449e4543275ac412ec06ed67ec98db1235a207b5"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260813.32.1-18184731", info.fetch("releaseTag")
    assert_equal "18184731cf128bf06ccc8a3c287a6b026f41b658", info.fetch("sourceSha")
    assert_equal "20260813124329.32.1", info.fetch("homebrewVersion")
  end
end
