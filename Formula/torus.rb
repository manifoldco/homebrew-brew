require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.18.0.tar.gz"
  sha256 "27d835fcd05f5d7d77fe48df4f50c83310b8543c629d56988e95f29ef1c1c388"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "0814a6d6914ee51be96d8088c3b7fa0420bf39c76d03577ed7101aa39e9e7efa" => :sierra
    sha256 "0814a6d6914ee51be96d8088c3b7fa0420bf39c76d03577ed7101aa39e9e7efa" => :el_capitan
    sha256 "0814a6d6914ee51be96d8088c3b7fa0420bf39c76d03577ed7101aa39e9e7efa" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.18.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.18.0/darwin/#{arch}/torus"
    end
  end
end
