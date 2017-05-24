require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.24.0.tar.gz"
  sha256 "b94d210b07d64d5547ad0ad7c41984c7d4739dc381c703c38de1408e9024415d"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "2544aee701234e46aabf20552b0823410752ba3739c853020a4e3472983f5e2c" => :sierra
    sha256 "2544aee701234e46aabf20552b0823410752ba3739c853020a4e3472983f5e2c" => :el_capitan
    sha256 "2544aee701234e46aabf20552b0823410752ba3739c853020a4e3472983f5e2c" => :yosemite
  end

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = buildpath/"glide_home"

    toruspath = buildpath/"src/github.com/manifoldco/torus-cli"
    toruspath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata" do
      system "go", "install", "github.com/jteeuwen/go-bindata/..."
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    cd toruspath do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV.deparallelize do
        system "make", "binary-darwin-#{arch}", "VERSION=0.24.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.24.0/darwin/#{arch}/torus"
    end
  end
end
