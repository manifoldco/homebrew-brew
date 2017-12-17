require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.28.1.tar.gz"
  sha256 "608e1ab78a3cb2fd97e113a6718c74a68adbfff0c93d2a595c1315b7da271c41"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "2194a1d9858d7a6a34d98ed583a1f3e35915a5112dd238a32e90bcd113a1c9cb" => :high_sierra
    sha256 "2194a1d9858d7a6a34d98ed583a1f3e35915a5112dd238a32e90bcd113a1c9cb" => :sierra
    sha256 "2194a1d9858d7a6a34d98ed583a1f3e35915a5112dd238a32e90bcd113a1c9cb" => :el_capitan
    sha256 "2194a1d9858d7a6a34d98ed583a1f3e35915a5112dd238a32e90bcd113a1c9cb" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.28.1", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.28.1/darwin/#{arch}/torus"
    end

    getting_started_url = "https://www.torus.sh/docs/latest/start-here/quickstart"
    ohai "Learn how to get started with Torus at #{getting_started_url}!"
  end
end
