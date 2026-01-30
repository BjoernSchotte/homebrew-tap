class Atlcli < Formula
  desc "CLI for Atlassian Confluence and Jira"
  homepage "https://atlcli.sh"
  version "0.14.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-arm64.tar.gz"
      sha256 "6d47414a1eda1ca4f5a1c19ac27f5e676350fbf16cad8c54745ad50fe1e45fe2"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-x64.tar.gz"
      sha256 "f10cf4f8076fe1accf374e9ea761e15c7fa957122881abb37772dd110783c7c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-arm64.tar.gz"
      sha256 "3520b443b9dce8210e44374194eabcfacc1df66475feb0d9aeda70fef5a1801d"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-x64.tar.gz"
      sha256 "ccc7c9649f410245099a677103451879a379f8c603896e57920e71ff980db26e"
    end
  end

  def install
    bin.install "atlcli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlcli version --json")
  end
end
