
require "language/go"

class Grafton< Formula
  desc "Manifold's provider validation tool"
  homepage "https://www.manifold.co/partners"
  url "https://github.com/manifoldco/grafton/archive/v0.16.2.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/grafton.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/grafton/brew/bottles"
    cellar :any_skip_relocation
    sha256 "29b48185eab08555fb63b80dadb08e89c76682e183e9fbed50bfdb9e5d2ee429" => :high_sierra
    sha256 "29b48185eab08555fb63b80dadb08e89c76682e183e9fbed50bfdb9e5d2ee429" => :sierra
    sha256 "29b48185eab08555fb63b80dadb08e89c76682e183e9fbed50bfdb9e5d2ee429" => :el_capitan
    sha256 "29b48185eab08555fb63b80dadb08e89c76682e183e9fbed50bfdb9e5d2ee429" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=v0.16.2", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.16.2/darwin/#{arch}/grafton"
    end
  end
end
