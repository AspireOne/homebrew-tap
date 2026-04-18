class CodexManage < Formula
  desc "Terminal UI for switching between Codex auth profiles"
  homepage "https://github.com/AspireOne/codex-auth-manager"
  url "https://github.com/AspireOne/codex-auth-manager/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "5acff7caddba282131c8d5c2e7fc91803e18d283786c580f5ab07e9ab23752e1"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/codex-manage"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex-manage --version")
  end
end
