require "json"

class AtlcliDev < Formula
  desc "Development channel for the Atlassian Confluence and Jira CLI"
  homepage "https://atlcli.sh"
  version "20260917074600.69.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260917.69.1-eb94264b/atlcli-darwin-arm64.tar.gz"
      sha256 "9b23c7a18232617c9e8429e2155f2ca05d6a3cc678d8d74bc6732d53420f35a5"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260917.69.1-eb94264b/atlcli-darwin-x64.tar.gz"
      sha256 "56b7578486ed3eabae39066b109da09bf446c8892fe7c7807c556d556d83b2ff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260917.69.1-eb94264b/atlcli-linux-arm64.tar.gz"
      sha256 "f4e634187b52079692108851fd359eb0909323aca4ae19cc551795cd589ba023"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/atlcli/releases/download/dev-20260917.69.1-eb94264b/atlcli-linux-x64.tar.gz"
      sha256 "dac5fa65c8552a7438265d63b8c3089ea7e6ef3917acf535ed282a80ff6ecf1a"
    end
  end

  conflicts_with "atlcli", because: "both formulae install the atlcli executable"

  def install
    bin.install "atlcli"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/atlcli release-info --json --no-log"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "dev-20260917.69.1-eb94264b", info.fetch("releaseTag")
    assert_equal "eb94264b010ff8c0e2ab0e59117213220ec37b75", info.fetch("sourceSha")
    assert_equal "20260917074600.69.1", info.fetch("homebrewVersion")
  end
end
