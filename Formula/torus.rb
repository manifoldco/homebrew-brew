require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.24.1.tar.gz"
  sha256 "f2bed90737cd940232fee541211788e3be4833608d38227b36c2078963128de1"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "054cc785cce18058d3eee22d3b028e527b858dc3f0d75663e393fa712b8c1d48" => :sierra
    sha256 "054cc785cce18058d3eee22d3b028e527b858dc3f0d75663e393fa712b8c1d48" => :el_capitan
    sha256 "054cc785cce18058d3eee22d3b028e527b858dc3f0d75663e393fa712b8c1d48" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.24.1", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.24.1/darwin/#{arch}/torus"
    end
  end
end
