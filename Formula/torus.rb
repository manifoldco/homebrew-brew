require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.26.0.tar.gz"
  sha256 "596f7d07ee02fa6e3d024fc5ccfa49c0a1718184c2ac3b582783411925b9b5a1"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "77ee7d57ba0e70505251bd7c7f800f31264084bcf07bda9b42db6138e1efd820" => :high_sierra
    sha256 "77ee7d57ba0e70505251bd7c7f800f31264084bcf07bda9b42db6138e1efd820" => :sierra
    sha256 "77ee7d57ba0e70505251bd7c7f800f31264084bcf07bda9b42db6138e1efd820" => :el_capitan
    sha256 "77ee7d57ba0e70505251bd7c7f800f31264084bcf07bda9b42db6138e1efd820" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.26.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.26.0/darwin/#{arch}/torus"
    end

    getting_started_url = "https://www.torus.sh/docs/latest/start-here/quickstart"
    ohai "Learn how to get started with Torus at #{getting_started_url}!"
  end
end
