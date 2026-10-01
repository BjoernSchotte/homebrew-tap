require "json"

class AgentglassDev < Formula
  desc "Development channel of agentglass (daily build of main)"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "20261001.3.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261001.3.1-3d70be12/agentglass-darwin-arm64.tar.gz"
      sha256 "adeac01abc79d8b3e58ff9c95108114780061b04f13d87f333da40946c303c7e"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261001.3.1-3d70be12/agentglass-darwin-x64.tar.gz"
      sha256 "28448f222ea8b82c7163b7e179320efd62324a0f83dee5669938f7be9b1175b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261001.3.1-3d70be12/agentglass-linux-arm64.tar.gz"
      sha256 "53103f98d179183210be33daa8944c79a9090866df7483987d1888e205b0779b"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261001.3.1-3d70be12/agentglass-linux-x64.tar.gz"
      sha256 "18830dcdbba4df0488573de4fffb0e325b3a588c6da054dbc6c638e393a3fe07"
    end
  end

  conflicts_with "agentglass", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/agentglass --version --json"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "3d70be12906019ee207efababf7cee6d1a099048", info.fetch("commit")
    assert_equal "2026.9.2-dev.20261001.3+3d70be12", info.fetch("version")
  end
end
