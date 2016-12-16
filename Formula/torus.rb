require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.21.0.tar.gz"
  sha256 "9fa79a587f6e79bb9c6a494e221bb8f594bd2013c2b44efc2644cdf616423f22"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "6e52af41dff0705b55dbe5587da3ebf051fc0b08a4f7af583e77550a6bd39c20" => :sierra
    sha256 "6e52af41dff0705b55dbe5587da3ebf051fc0b08a4f7af583e77550a6bd39c20" => :el_capitan
    sha256 "6e52af41dff0705b55dbe5587da3ebf051fc0b08a4f7af583e77550a6bd39c20" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.21.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.21.0/darwin/#{arch}/torus"
    end
  end
end
