
require "language/go"

class ManifoldCli< Formula
  desc "Manage your services and config from the command line"
  homepage "https://www.manifold.co/cli"
  url "https://github.com/manifoldco/manifold-cli/archive/v0.15.0.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/manifold-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/manifold-cli/brew/bottles"
    cellar :any_skip_relocation
    sha256 "5ddf001817811e466582580386c84ab1eaf409b03d912ddd3db7b8a62b321765" => :high_sierra
    sha256 "5ddf001817811e466582580386c84ab1eaf409b03d912ddd3db7b8a62b321765" => :sierra
    sha256 "5ddf001817811e466582580386c84ab1eaf409b03d912ddd3db7b8a62b321765" => :el_capitan
    sha256 "5ddf001817811e466582580386c84ab1eaf409b03d912ddd3db7b8a62b321765" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=v0.15.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.15.0/darwin/#{arch}/manifold"
    end
  end
end
