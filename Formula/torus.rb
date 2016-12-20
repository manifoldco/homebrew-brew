require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.21.1.tar.gz"
  sha256 "4e2e3c2757dacb4384dd2b2b6c42f4baea38889a0b6ac3937b77952da9d6b0aa"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "4e668d58f56fdfc4ac33c094b469f13e2ac565612c96f81559d21baa16d7db66" => :sierra
    sha256 "4e668d58f56fdfc4ac33c094b469f13e2ac565612c96f81559d21baa16d7db66" => :el_capitan
    sha256 "4e668d58f56fdfc4ac33c094b469f13e2ac565612c96f81559d21baa16d7db66" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.21.1", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.21.1/darwin/#{arch}/torus"
    end
  end
end
