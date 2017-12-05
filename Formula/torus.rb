require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.28.0.tar.gz"
  sha256 "b963f3da7887d9c58fa2ce067b066d17bd7f1155bd1aac21471bb3cc4868bee3"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "6191abf35298b8ba5a1ddb28ef89c2d5a229c2346211ba84b28505b6c08739f0" => :high_sierra
    sha256 "6191abf35298b8ba5a1ddb28ef89c2d5a229c2346211ba84b28505b6c08739f0" => :sierra
    sha256 "6191abf35298b8ba5a1ddb28ef89c2d5a229c2346211ba84b28505b6c08739f0" => :el_capitan
    sha256 "6191abf35298b8ba5a1ddb28ef89c2d5a229c2346211ba84b28505b6c08739f0" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.28.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.28.0/darwin/#{arch}/torus"
    end

    getting_started_url = "https://www.torus.sh/docs/latest/start-here/quickstart"
    ohai "Learn how to get started with Torus at #{getting_started_url}!"
  end
end
