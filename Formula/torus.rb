require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.25.0.tar.gz"
  sha256 "a2c1f825f98c901afedd671b8ee9eda747c55d3d7f6f23d1f378556fa4476455"
  head "https://github.com/manifoldco/torus-cli.git"
  getting_started_url "https://www.torus.sh/docs/latest/start-here/quickstart"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "08ab3bb2ee351f9172c550c7e2f4af9d67eb5231902e67d083b12bb2af1b0361" => :high_sierra
    sha256 "08ab3bb2ee351f9172c550c7e2f4af9d67eb5231902e67d083b12bb2af1b0361" => :sierra
    sha256 "08ab3bb2ee351f9172c550c7e2f4af9d67eb5231902e67d083b12bb2af1b0361" => :el_capitan
    sha256 "08ab3bb2ee351f9172c550c7e2f4af9d67eb5231902e67d083b12bb2af1b0361" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.25.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.25.0/darwin/#{arch}/torus"
    end

    ohai "Learn how to get started with Torus at #{getting_started_url}!"
  end
end
