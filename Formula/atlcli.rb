class Atlcli < Formula
  desc "CLI for Atlassian Confluence and Jira"
  homepage "https://atlcli.sh"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-arm64.tar.gz"
      sha256 "b5379269a03b5e78ce3f0b0ce0beb580a4e581d2779d393b72d44d441d21f4bd"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-darwin-x64.tar.gz"
      sha256 "89eca36f8379261ca85518813a6ecd64af821de6f82ba5dbd29322a73473004b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-arm64.tar.gz"
      sha256 "68e5f94f5679063aa3b00a06754045c50de5e01c794f4eeef905dfd31ab64c4f"
    end
    on_intel do
      url "https://github.com/bjoernschotte/atlcli/releases/download/v#{version}/atlcli-linux-x64.tar.gz"
      sha256 "7b61d3a129a4ebf52ac56ef2335386d82a94a34b7b1dae3a76abe7c298147f56"
    end
  end

  def install
    bin.install "atlcli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlcli version --json")
  end
end
