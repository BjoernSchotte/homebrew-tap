require "json"

class AgentglassDev < Formula
  desc "Development channel of agentglass (daily build of main)"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "20261007.9.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261007.9.1-5024702a/agentglass-darwin-arm64.tar.gz"
      sha256 "d443cb4d31e4872404a81830539407b9af59e7dc6830c56dc6249fb643a0ba49"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261007.9.1-5024702a/agentglass-darwin-x64.tar.gz"
      sha256 "30336a13e42a00aa717cf15838c5e93195c937c341ce8dc9affd84955d777c93"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261007.9.1-5024702a/agentglass-linux-arm64.tar.gz"
      sha256 "b24d543cc94a0f07320768995f56ac5d065b0f04280ee907bd3113070920bc41"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261007.9.1-5024702a/agentglass-linux-x64.tar.gz"
      sha256 "6feb0bbfea92744ff3c429bdce343728218a402013fe62af113eee49f3a2fa85"
    end
  end

  conflicts_with "agentglass", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/agentglass --version --json"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "5024702ac396da2f2eef9410619de9a272c57899", info.fetch("commit")
    assert_equal "2026.10.9-dev.20261007.9+5024702a", info.fetch("version")
  end
end
