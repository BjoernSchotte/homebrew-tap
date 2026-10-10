class Agentglass < Formula
  desc "See every coding agent on your machine — live, down to every tool call"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "2026.10.12"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-arm64.tar.gz"
      sha256 "a4d8f825660d1a0649cbc9dcd71858326b0e45310abd5b8d4640b8bc5a65a964"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-x64.tar.gz"
      sha256 "0d00991caaf385c8d6064be4cefd30446aa4af6cba1ac81c09993e36e2bf14f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-arm64.tar.gz"
      sha256 "030043ee36bfbb327d02e008a25f14229e34a4962d1cc3d503f96419446b2274"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-x64.tar.gz"
      sha256 "2518578f12ee2f150cf7c9c29d77ace5081af8a2bdd4d0a1c56c14ee0efd1c02"
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
