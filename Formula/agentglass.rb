class Agentglass < Formula
  desc "See every coding agent on your machine — live, down to every tool call"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "2026.10.5"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-arm64.tar.gz"
      sha256 "4c44b855a12ec1feca2ce6d20ac5d9f3255ac3eedc2a77de196c9e1d78e6b96f"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-x64.tar.gz"
      sha256 "f50e80a998e69ff0161844147d3567d443efe518abbd1f988a23d40f94104812"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-arm64.tar.gz"
      sha256 "1cb3554843582d2d727dae6e418a85dce7a9769f572a27272203ee5788a0d51f"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-x64.tar.gz"
      sha256 "acf30543a7405d74f21ddad651aaa057adaed8e6494507b80db9778ce4272007"
    end
  end

  conflicts_with "agentglass-dev", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentglass --version")
  end
end
