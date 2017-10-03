
require "language/go"

class ManifoldCli< Formula
  desc "Manifold CLI"
  homepage "https://www.manifold.co/cli"
  url "https://github.com/manifoldco/manifold-cli/archive/v0.6.0.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/manifold-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/manifold-cli/brew/bottles"
    cellar :any_skip_relocation
    sha256 "74f188608b407ecb28070b17dd84dbc7776ffcdc28380c8ea424b845ce48521e" => :high_sierra
    sha256 "74f188608b407ecb28070b17dd84dbc7776ffcdc28380c8ea424b845ce48521e" => :sierra
    sha256 "74f188608b407ecb28070b17dd84dbc7776ffcdc28380c8ea424b845ce48521e" => :el_capitan
    sha256 "74f188608b407ecb28070b17dd84dbc7776ffcdc28380c8ea424b845ce48521e" => :yosemite
  end

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = buildpath/"glide_home"

    pkgpath = buildpath/"src/github.com/manifoldco/manifold-cli"
    pkgpath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata" do
      system "go", "install", "github.com/jteeuwen/go-bindata/..."
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    cd pkgpath do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV.deparallelize do
        system "make", "binary-darwin-#{arch}", "VERSION=v0.6.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.6.0/darwin/#{arch}/manifold"
    end
  end
end
