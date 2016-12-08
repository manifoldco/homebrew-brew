require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.19.0.tar.gz"
  sha256 "b92b9288d9a84374779e2cc36852fae61542af9759ea7c8a2dffb1be7e8f84fb"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "49143a7e7d9debaac284a681eb7ca87728781da8a86a1c19995297631e29483e" => :sierra
    sha256 "49143a7e7d9debaac284a681eb7ca87728781da8a86a1c19995297631e29483e" => :el_capitan
    sha256 "49143a7e7d9debaac284a681eb7ca87728781da8a86a1c19995297631e29483e" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.19.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.19.0/darwin/#{arch}/torus"
    end
  end
end
