
require "language/go"

class Grafton< Formula
  desc "Manifold's provider validation tool"
  homepage "<https://docs.manifold.co>"
  url "https://github.com/manifoldco/grafton/archive/v0.14.5.tar.gz"
  sha256 ""
  head "https://github.com/manifoldco/grafton.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://releases.manifold.co/grafton/brew/bottles"
    cellar :any_skip_relocation
    sha256 "747341aa69878abe8d46b6bf5a998ba36aa69358200d028bb65090e9aa0f8eef" => :high_sierra
    sha256 "747341aa69878abe8d46b6bf5a998ba36aa69358200d028bb65090e9aa0f8eef" => :sierra
    sha256 "747341aa69878abe8d46b6bf5a998ba36aa69358200d028bb65090e9aa0f8eef" => :el_capitan
    sha256 "747341aa69878abe8d46b6bf5a998ba36aa69358200d028bb65090e9aa0f8eef" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=v0.14.5", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/v0.14.5/darwin/#{arch}/grafton"
    end
  end
end
