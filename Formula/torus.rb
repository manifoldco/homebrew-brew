require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.24.2.tar.gz"
  sha256 "6f4b763e9e53772221fcd8410fe147a6d472a3dd88ca1c0c41e324820ebbad59"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "ed865dd8ad094c309b32b87c5beccb89397eb2df619785af0bce2fda34e64957" => :sierra
    sha256 "ed865dd8ad094c309b32b87c5beccb89397eb2df619785af0bce2fda34e64957" => :el_capitan
    sha256 "ed865dd8ad094c309b32b87c5beccb89397eb2df619785af0bce2fda34e64957" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.24.2", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.24.2/darwin/#{arch}/torus"
    end
  end
end
