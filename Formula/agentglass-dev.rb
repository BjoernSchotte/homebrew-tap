require "json"

class AgentglassDev < Formula
  desc "Development channel of agentglass (daily build of main)"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "20261008.10.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261008.10.1-da8df49c/agentglass-darwin-arm64.tar.gz"
      sha256 "f68fea5d9be8b36637f00e4dc9176f70125d202ab1c2556f7fea9cf3b1a7b0ca"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261008.10.1-da8df49c/agentglass-darwin-x64.tar.gz"
      sha256 "d1ec9e4359fa11aba6d53234149e8e6493d3f9ac2ec7609f85ff83b8e2af9d15"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261008.10.1-da8df49c/agentglass-linux-arm64.tar.gz"
      sha256 "61dc5bad1a159a8c68b6a00ddbfea960739047b82e1fab2764e1bef66897c042"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261008.10.1-da8df49c/agentglass-linux-x64.tar.gz"
      sha256 "2810ffeb6ab5ac66804731f841d4c0606884bb82575a7867931f5f73a4ed1fad"
    end
  end

  conflicts_with "agentglass", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/agentglass --version --json"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "da8df49cd0cde7b53f1147cfa33f91535887f110", info.fetch("commit")
    assert_equal "2026.10.10-dev.20261008.10+da8df49c", info.fetch("version")
  end
end
