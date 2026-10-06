class Agentglass < Formula
  desc "See every coding agent on your machine — live, down to every tool call"
  homepage "https://github.com/BjoernSchotte/agentglass"
  version "2026.10.8"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-arm64.tar.gz"
      sha256 "db5cb93b5f7f4ebd972ab351a2b2e3f1200cd94ce3ec69f79a30729f4b3c3fc6"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-darwin-x64.tar.gz"
      sha256 "de746db65c25acabfb5cbf29f131eeaf984309ee38c18efad5f9cfaab1dbb39e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-arm64.tar.gz"
      sha256 "50c183fe39f776085a448ab38d67271fcb5915976263fa8146561bcc9579183c"
    end
    on_intel do
      url "https://github.com/BjoernSchotte/agentglass/releases/download/v#{version}/agentglass-linux-x64.tar.gz"
      sha256 "2b6768c0631eba1275df30b7eafa9fed4068b2dec163024eb94bfd9ea775f747"
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
