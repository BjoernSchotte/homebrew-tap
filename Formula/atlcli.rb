class Atlcli < Formula
  desc "CLI for Atlassian Confluence and Jira"
  homepage "https://atlcli.sh"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-arm64.tar.gz"
      sha256 "684aa4e1d297f1841a4978f28ca463c5d04a7a768de3fc2439c58597f55a35b5"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-x64.tar.gz"
      sha256 "00338d2ee527393fec05be0bce188c7d7233acc99570cf59f4da5febc78e7433"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-arm64.tar.gz"
      sha256 "b6dfd0128d1161483df54a0b709517cb73a958d73246ebe53f2b6b13aa824827"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-x64.tar.gz"
      sha256 "f2d1533086e02fa82262242117cab56d2f64541ae0915d9a2b6c48844cb362cd"
    end
  end

  def install
    bin.install "atlcli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlcli version --json")
  end
end
