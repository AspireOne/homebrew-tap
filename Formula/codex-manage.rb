class CodexManage < Formula
  desc "Terminal UI for switching between Codex auth profiles"
  homepage "https://github.com/AspireOne/codex-auth-manager"
  url "https://github.com/AspireOne/codex-auth-manager/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "8110cafe7b1e50d2efc1ce1c7e68ec7f1abc1f673b63d34a8436940cca4d22f9"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/codex-manage"
  end

  test do
    assert_path_exists bin/"codex-manage"
  end
end
