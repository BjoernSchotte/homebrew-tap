class Agentglass < Formula
  desc "See every coding agent on your machine — live, down to every tool call"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "2026.10.13"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-arm64.tar.gz"
      sha256 "e5211078571625ea4d5b1ad64ac78dba147e538cc500beec4bf9fca681f90c78"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-x64.tar.gz"
      sha256 "4f46ab283de8832f7735932322739362cdef99f7a69cfd2897fbfdeeb074ef8c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-arm64.tar.gz"
      sha256 "e25a3709f72715eed520e6d88e0694ed4e644199398a5f1658fd138cb026632f"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-x64.tar.gz"
      sha256 "59f86067b1c6c7c4cef93748865f4fd3b5b275fb8ca24d3c9aee170ca85eaf06"
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
