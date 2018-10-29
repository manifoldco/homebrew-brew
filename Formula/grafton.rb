
require "language/go"

class Grafton< Formula
  desc "Manifold's provider validation tool"
  homepage "<https://docs.manifold.co>"
  url "https://github.com/manifoldco/grafton/archive/v0.14.1.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/grafton.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/grafton/brew/bottles"
    cellar :any_skip_relocation
    sha256 "9bfc57d61e6653998f700d5e18ff6c4578da4208b6d1b252efe0be102a74bafd" => :high_sierra
    sha256 "9bfc57d61e6653998f700d5e18ff6c4578da4208b6d1b252efe0be102a74bafd" => :sierra
    sha256 "9bfc57d61e6653998f700d5e18ff6c4578da4208b6d1b252efe0be102a74bafd" => :el_capitan
    sha256 "9bfc57d61e6653998f700d5e18ff6c4578da4208b6d1b252efe0be102a74bafd" => :yosemite
  end

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = buildpath/"glide_home"

    pkgpath = buildpath/"src/github.com/manifoldco/grafton"
    pkgpath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata" do
      system "go", "install", "github.com/jteeuwen/go-bindata/..."
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    cd pkgpath do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV.deparallelize do
        system "make", "binary-darwin-#{arch}", "VERSION=v0.14.1", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.14.1/darwin/#{arch}/grafton"
    end
  end
end
