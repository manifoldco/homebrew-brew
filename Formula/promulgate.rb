
require "language/go"

class Promulgate< Formula
  desc "Manifold's release tool"
  homepage "https://www.manifold.co"
  url "https://github.com/manifoldco/promulgate/archive/v0.0.9.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/promulgate.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/promulgate/brew/bottles"
    cellar :any_skip_relocation
    sha256 "7e6a8248781962cf6d5227b610e342181db290e08c1a35e37d21ca5e15db30bd" => :high_sierra
    sha256 "7e6a8248781962cf6d5227b610e342181db290e08c1a35e37d21ca5e15db30bd" => :sierra
    sha256 "7e6a8248781962cf6d5227b610e342181db290e08c1a35e37d21ca5e15db30bd" => :el_capitan
    sha256 "7e6a8248781962cf6d5227b610e342181db290e08c1a35e37d21ca5e15db30bd" => :yosemite
  end

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = buildpath/"glide_home"

    pkgpath = buildpath/"src/github.com/manifoldco/promulgate"
    pkgpath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata" do
      system "go", "install", "github.com/jteeuwen/go-bindata/..."
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    cd pkgpath do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV.deparallelize do
        system "make", "binary-darwin-#{arch}", "VERSION=v0.0.9", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.0.9/darwin/#{arch}/promulgate"
    end
  end
end
