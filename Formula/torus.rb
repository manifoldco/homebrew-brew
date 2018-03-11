require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.30.0.tar.gz"
  sha256 "ac01bf2dbf8672fea7dab9a0895ad749462e993ba1fc999f0243f0054ee562ab"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "69f7c3f1f8223a95e1fe6e746c69ab672eef40a0b640e1e590bc6d9e8530fe72" => :high_sierra
    sha256 "69f7c3f1f8223a95e1fe6e746c69ab672eef40a0b640e1e590bc6d9e8530fe72" => :sierra
    sha256 "69f7c3f1f8223a95e1fe6e746c69ab672eef40a0b640e1e590bc6d9e8530fe72" => :el_capitan
    sha256 "69f7c3f1f8223a95e1fe6e746c69ab672eef40a0b640e1e590bc6d9e8530fe72" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.30.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.30.0/darwin/#{arch}/torus"
    end

    getting_started_url = "https://www.torus.sh/docs/latest/start-here/quickstart"
    ohai "Learn how to get started with Torus at #{getting_started_url}!"
  end
end
