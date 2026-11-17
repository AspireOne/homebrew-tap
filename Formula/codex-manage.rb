class CodexManage < Formula
  desc "Terminal UI for switching between Codex auth profiles"
  homepage "https://github.com/AspireOne/codex-auth-manager"
  url "https://github.com/AspireOne/codex-auth-manager/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "78cdf0c1b6fcb183ddd08f2216fe0cf0c94389a8c0e97e0063d53579b7a5c054"
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
