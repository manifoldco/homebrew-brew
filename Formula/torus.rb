require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.17.0.tar.gz"
  sha256 "c36a8e87276228af1ea07ae6c14467ab18812e4f2c32b50eb354c7a3bfc086c1"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "4e3195736ceb3b78235783e1ddc6dece3464837fc65f357cc3d47650707f1d8d" => :sierra
    sha256 "4e3195736ceb3b78235783e1ddc6dece3464837fc65f357cc3d47650707f1d8d" => :el_capitan
    sha256 "4e3195736ceb3b78235783e1ddc6dece3464837fc65f357cc3d47650707f1d8d" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.17.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.17.0/darwin/#{arch}/torus"
    end
  end
end
