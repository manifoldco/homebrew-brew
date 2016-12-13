require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.20.0.tar.gz"
  sha256 "4b2f77b3c1178ea4c97dbca15063c45b6f31fcdac18467fd6fae8fda7b570335"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "b57eed4ff85d9210193ebd2dbbe673a02ff6210e87762f94bb973e8d9aed5659" => :sierra
    sha256 "b57eed4ff85d9210193ebd2dbbe673a02ff6210e87762f94bb973e8d9aed5659" => :el_capitan
    sha256 "b57eed4ff85d9210193ebd2dbbe673a02ff6210e87762f94bb973e8d9aed5659" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.20.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.20.0/darwin/#{arch}/torus"
    end
  end
end
