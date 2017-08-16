
require "language/go"

class ManifoldCli< Formula
  desc "A prototype of a possible Manifold CLI"
  homepage "https://www.manifold.co"
  url "https://github.com/manifoldco/manifold-cli/archive/v0.2.6.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/manifold-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/manifold-cli/brew/bottles"
    cellar :any_skip_relocation
    sha256 "a040336c2614efd847d23acc51aac8fd0163001b3279d0642dd8c04790be8df8" => :sierra
    sha256 "a040336c2614efd847d23acc51aac8fd0163001b3279d0642dd8c04790be8df8" => :el_capitan
    sha256 "a040336c2614efd847d23acc51aac8fd0163001b3279d0642dd8c04790be8df8" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=v0.2.6", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.2.6/darwin/#{arch}/manifold"
    end
  end
end
