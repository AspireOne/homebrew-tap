class CodexManage < Formula
  desc "Terminal UI for switching between Codex auth profiles"
  homepage "https://github.com/AspireOne/codex-auth-manager"
  url "https://github.com/AspireOne/codex-auth-manager/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "a0fa2db238674bdb92a54ea0eb933c119af56b4cc4fa4e37fc992ce3d344b080"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/codex-manage"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex-manage --version")
  end
end
