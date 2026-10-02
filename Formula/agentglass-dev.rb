require "json"

class AgentglassDev < Formula
  desc "Development channel of agentglass (daily build of main)"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "20261002.4.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261002.4.1-87c10d40/agentglass-darwin-arm64.tar.gz"
      sha256 "07938d76b3c624aa3885cb2365da8385f5de558d4fe92a6f4256bdff02039373"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261002.4.1-87c10d40/agentglass-darwin-x64.tar.gz"
      sha256 "089d718a64d54428905ca4b0ecd6e1f7b81a9e5efbacb04085e4e379630a5e2f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261002.4.1-87c10d40/agentglass-linux-arm64.tar.gz"
      sha256 "299b42a929afe05432ccaa8173551255c088f7167a4b72415c030400e1402bbb"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/dev-20261002.4.1-87c10d40/agentglass-linux-x64.tar.gz"
      sha256 "b82216361cdac467a69c432d532efa8fe5570ade9d8dbc71e7fd61fd60505fa2"
    end
  end

  conflicts_with "agentglass", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
  end

  test do
    info = JSON.parse(shell_output("#{bin}/agentglass --version --json"))
    assert_equal "dev", info.fetch("channel")
    assert_equal "87c10d400496f460147297fc9725ad52a6c74b1a", info.fetch("commit")
    assert_equal "2026.10.2-dev.20261002.4+87c10d40", info.fetch("version")
  end
end
