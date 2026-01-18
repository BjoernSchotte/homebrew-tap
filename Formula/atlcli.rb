class Atlcli < Formula
  desc "CLI for Atlassian Confluence and Jira"
  homepage "https://atlcli.sh"
  version "0.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-arm64.tar.gz"
      sha256 "e6281f45255e70f8fa261e27930753a230aa1ee997ca0e12c756a6b963bd57aa"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-x64.tar.gz"
      sha256 "3bfe69aecf85cae5ef43965abeb5b9475a356a3f4ac3a74d0176bc7cab73f775"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-arm64.tar.gz"
      sha256 "0abc792e5e15182c3b90ad2f4fb00e1264954054fcc688bdf470b2324adeb54b"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-x64.tar.gz"
      sha256 "0267e099f7a9d8298c9db2ae18c442e4bbeecea837e56518e40bf1dcc2186aed"
    end
  end

  def install
    bin.install "atlcli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlcli version --json")
  end
end
