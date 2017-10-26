
require "language/go"

class ManifoldCli< Formula
  desc "Manifold CLI"
  homepage "https://www.manifold.co/cli"
  url "https://github.com/manifoldco/manifold-cli/archive/v0.9.1.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/manifold-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/manifold-cli/brew/bottles"
    cellar :any_skip_relocation
    sha256 "1230b69ff928d9faf81b43e7de4d3e1b9333a96702ae6df36baeff89444f044d" => :high_sierra
    sha256 "1230b69ff928d9faf81b43e7de4d3e1b9333a96702ae6df36baeff89444f044d" => :sierra
    sha256 "1230b69ff928d9faf81b43e7de4d3e1b9333a96702ae6df36baeff89444f044d" => :el_capitan
    sha256 "1230b69ff928d9faf81b43e7de4d3e1b9333a96702ae6df36baeff89444f044d" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=v0.9.1", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.9.1/darwin/#{arch}/manifold"
    end
  end
end
