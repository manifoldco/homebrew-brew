
require "language/go"

class ManifoldCli< Formula
  desc "Manage your services and config from the command line"
  homepage "https://www.manifold.co/cli"
  url "https://github.com/manifoldco/manifold-cli/archive/v0.13.0.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/manifold-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/manifold-cli/brew/bottles"
    cellar :any_skip_relocation
    sha256 "a652d82dd84ef13ec0bf6d07f8e2e3d2c4ecfed4b2ad09d3ba58e8a25ec659ba" => :high_sierra
    sha256 "a652d82dd84ef13ec0bf6d07f8e2e3d2c4ecfed4b2ad09d3ba58e8a25ec659ba" => :sierra
    sha256 "a652d82dd84ef13ec0bf6d07f8e2e3d2c4ecfed4b2ad09d3ba58e8a25ec659ba" => :el_capitan
    sha256 "a652d82dd84ef13ec0bf6d07f8e2e3d2c4ecfed4b2ad09d3ba58e8a25ec659ba" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=v0.13.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.13.0/darwin/#{arch}/manifold"
    end
  end
end
