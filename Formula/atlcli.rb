class Atlcli < Formula
  desc "CLI for Atlassian Confluence and Jira"
  homepage "https://atlcli.sh"
  version "0.16.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-arm64.tar.gz"
      sha256 "754890a4a2c885324e1ea77d0c448b4bc3ec7ec60bc2b02bd561dd8d33e7793e"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-x64.tar.gz"
      sha256 "f7837fb857662618bfae36d48624d6ef4d04236c449f01932d6395490d9b93ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-arm64.tar.gz"
      sha256 "9a8c836008668a51393e46f05d57c867610674c8c6d612d0b586bbc7a74210ef"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-x64.tar.gz"
      sha256 "03f1e482f42f5580ee8f2f68099ed374b1672dd1bafec2abd7c4fd5066f59d7d"
    end
  end

  def install
    bin.install "atlcli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlcli version --json")
  end
end
