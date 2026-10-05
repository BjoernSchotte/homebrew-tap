class Agentglass < Formula
  desc "See every coding agent on your machine — live, down to every tool call"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "2026.10.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-arm64.tar.gz"
      sha256 "03a616ffb00a3fd84297489026a78ad309a65140d0ae503f4f19da3bee81a41f"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-x64.tar.gz"
      sha256 "544aefc4dd000bb2a10620454785828945b8af7f43b36926a87cbf468a3be415"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-arm64.tar.gz"
      sha256 "f986766d4e41695bd4a371aef7ca0dc35900e9ad5e9ccae34f8c3efb716e41b4"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-x64.tar.gz"
      sha256 "017d7e2ca307e67a4ed0cb59ed423c5809afb7ceff8b85fce0d768d131752852"
    end
  end

  conflicts_with "agentglass-dev", because: "both formulae install the agentglass executable"

  def install
    bin.install "agentglass"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentglass --version")
  end
end
