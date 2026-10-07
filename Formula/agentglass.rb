class Agentglass < Formula
  desc "See every coding agent on your machine — live, down to every tool call"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "2026.10.10"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-arm64.tar.gz"
      sha256 "6a8c2520f5bbd836729972955d7484a2ffb1bc1930f6739b844ad17e20fca31f"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-x64.tar.gz"
      sha256 "27d8c108753655b41c6808dae5dc2cd3e0d4559a400a3ee298adb49bd61721ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-arm64.tar.gz"
      sha256 "1a4568252d91a884fd257cf5cb90262bc7bfaf8be9f7d74f7950c40fe33b47f0"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-x64.tar.gz"
      sha256 "e718899888fb6fec7b56999ec1e2331a4d656e223408ee8d6bef6cece47d5476"
    end
  end

  conflicts_with "agentglass-dev", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
    # agentglass receive with built-in HTTPS; a target whose TLS build failed ships without it
    bin.install "agentglass-receive-tls" if File.exist?("agentglass-receive-tls")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentglass --version")
    if (bin/"agentglass-receive-tls").exist?
      assert_match version.to_s, shell_output("#{bin}/agentglass-receive-tls --version")
    end
  end
end
