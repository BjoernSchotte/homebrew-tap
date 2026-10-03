require "json"

class AgentglassDev < Formula
  desc "Development channel of agentglass (daily build of main)"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "20261003.5.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261003.5.1-366c810d/agentglass-darwin-arm64.tar.gz"
      sha256 "dd92d5c88577963201d9cb02989ea9b3cae320a90e8f0ce23bd9ac5912c4b6b8"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261003.5.1-366c810d/agentglass-darwin-x64.tar.gz"
      sha256 "f279563d23a2dabd36ffeed20f97da1509e5dab36953c41e59fe374a96e7021b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261003.5.1-366c810d/agentglass-linux-arm64.tar.gz"
      sha256 "2c216370f956fbf4f247620e16057651f54c757d4d35e6bbbfa590d981dead39"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261003.5.1-366c810d/agentglass-linux-x64.tar.gz"
      sha256 "9564cf1b9a5d3ded48d2713b93a384c19c27d87a1fc84805e8e79b43dc293985"
    end
  end

  conflicts_with "agentglass", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/agentglass --version --json"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "366c810d2afdf4248ba6a86e04af728767ea473a", info.fetch("commit")
    assert_equal "2026.10.2-dev.20261003.5+366c810d", info.fetch("version")
  end
end
