require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.23.0.tar.gz"
  sha256 "a5be6f77e9598da0682b889f1bcc2723ff6213338d0a9dca701bd96afebd23d3"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "b6ecf242258f955b205a9e50d7d73253ee8045b0efa080f94958288d08b6780d" => :sierra
    sha256 "b6ecf242258f955b205a9e50d7d73253ee8045b0efa080f94958288d08b6780d" => :el_capitan
    sha256 "b6ecf242258f955b205a9e50d7d73253ee8045b0efa080f94958288d08b6780d" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.23.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.23.0/darwin/#{arch}/torus"
    end
  end
end
