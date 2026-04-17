class CodexManage < Formula
  desc "Terminal UI for switching between Codex auth profiles"
  homepage "https://github.com/AspireOne/codex-auth-manager"
  url "https://github.com/AspireOne/codex-auth-manager/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "bf2f47e2ee89480978b6fe5028309ff4edaa122707e68d3c1e330fe3bc27becc"
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
