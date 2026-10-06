class Agentglass < Formula
  desc "See every coding agent on your machine — live, down to every tool call"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "2026.10.6"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-arm64.tar.gz"
      sha256 "4028ed0af7a7b45757d7d6c0ef384731ea884f81640339403e015fbdbd5dd20b"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-x64.tar.gz"
      sha256 "7ae501e67f4e1224b1f08d3b52aec57f9eb7e212240a4abda309cfd5a3b29078"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-arm64.tar.gz"
      sha256 "7baddb8e61531429b8ade2846b6f1b171152e86c2dadfa57b86b2912a5b65c50"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-x64.tar.gz"
      sha256 "d0d8a4a7a81051d6e9553c9cb827514c95b732ad792397793c5b2f05e35ae3f8"
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
