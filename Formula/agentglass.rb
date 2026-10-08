class Agentglass < Formula
  desc "See every coding agent on your machine — live, down to every tool call"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "2026.10.11"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-arm64.tar.gz"
      sha256 "6ac6d3b87080edd5dfa57b3fa9fa112c90afeecaeb6ea4a506e210fcdb33d246"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-x64.tar.gz"
      sha256 "7e02c97db33939d95f5468bd32fc477457cde304ebe0bcb7a9d38a8d36fef5c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-arm64.tar.gz"
      sha256 "04e21ba0ef3e96c3acd0f7c0c1c57a9d7645a4286e41713b8c9b9a734a323918"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-x64.tar.gz"
      sha256 "05d0025511323ba10f52c5d0c013b65612b8e0d2137bb39d75591db2bc0e4eb5"
    end
  end

  conflicts_with "agentglass-dev", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
    bin.install "agentglass-mcp" # the MCP server: agentglass mcp install registers it with coding agents
    # agentglass receive with built-in HTTPS; a target whose TLS build failed ships without it
    bin.install "agentglass-receive-tls" if File.exist?("agentglass-receive-tls")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentglass --version")
    assert_match version.to_s, shell_output("#{bin}/agentglass-mcp --version")
    if (bin/"agentglass-receive-tls").exist?
      assert_match version.to_s, shell_output("#{bin}/agentglass-receive-tls --version")
    end
  end
end
