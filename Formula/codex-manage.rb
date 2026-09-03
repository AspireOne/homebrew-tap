class CodexManage < Formula
  desc "Terminal UI for switching between Codex auth profiles"
  homepage "https://github.com/AspireOne/codex-auth-manager"
  url "https://github.com/AspireOne/codex-auth-manager/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "46b9da4927c0afd3bcd81cf022f3bc9e6dc5ace6d26f191176e22c73ff48021b"
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
