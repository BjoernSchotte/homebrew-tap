require "json"

class AgentglassDev < Formula
  desc "Development channel of agentglass (daily build of main)"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "20261011.13.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261011.13.1-2a709f37/agentglass-darwin-arm64.tar.gz"
      sha256 "50c318c5fa3859d98f8a19533bc632b07daf1b19c4269d09db7a6b8c2b7c6a5f"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261011.13.1-2a709f37/agentglass-darwin-x64.tar.gz"
      sha256 "f37624895c3468be8d4dcb64ccac16fc6c7685e0d93c69e3d5412e5726c8efc9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261011.13.1-2a709f37/agentglass-linux-arm64.tar.gz"
      sha256 "a013eb57c3b051f92db43894dcadf605a5a72976180d74a1687562bbdca9b98c"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261011.13.1-2a709f37/agentglass-linux-x64.tar.gz"
      sha256 "967737262d58b41bc6333b1b847c163e383b06269313983624b3428cc759e5f1"
    end
  end

  conflicts_with "agentglass", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/agentglass --version --json"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "2a709f3700fbd13761647d9937313865c88bcf87", info.fetch("commit")
    assert_equal "2026.10.13-dev.20261011.13+2a709f37", info.fetch("version")
  end
end
