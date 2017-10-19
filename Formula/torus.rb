require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.25.2.tar.gz"
  sha256 "f9f69c50473f029a4a2bf648ee4315e7b31e3fbf5ec6e0dd1306149e90396127"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "320ad8e278780f7f28c0ad9bccd19820db4c246154481c4bf5e289683ba05ec1" => :high_sierra
    sha256 "320ad8e278780f7f28c0ad9bccd19820db4c246154481c4bf5e289683ba05ec1" => :sierra
    sha256 "320ad8e278780f7f28c0ad9bccd19820db4c246154481c4bf5e289683ba05ec1" => :el_capitan
    sha256 "320ad8e278780f7f28c0ad9bccd19820db4c246154481c4bf5e289683ba05ec1" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.25.2", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.25.2/darwin/#{arch}/torus"
    end

    getting_started_url = "https://www.torus.sh/docs/latest/start-here/quickstart"
    ohai "Learn how to get started with Torus at #{getting_started_url}!"
  end
end
