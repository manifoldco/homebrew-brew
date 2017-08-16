
require "language/go"

class Promulgate< Formula
  desc "Manifold's release tool"
  homepage "https://www.manifold.co"
  url "https://github.com/manifoldco/promulgate/archive/v0.0.5.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/promulgate.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/promulgate/brew/bottles"
    cellar :any_skip_relocation
    sha256 "d6842f462147c566d52b0517a302182d9e7883a0ee1a1ddcb39b17925afc6e42" => :sierra
    sha256 "d6842f462147c566d52b0517a302182d9e7883a0ee1a1ddcb39b17925afc6e42" => :el_capitan
    sha256 "d6842f462147c566d52b0517a302182d9e7883a0ee1a1ddcb39b17925afc6e42" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=v0.0.5", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.0.5/darwin/#{arch}/promulgate"
    end
  end
end
