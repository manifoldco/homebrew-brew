require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.27.0.tar.gz"
  sha256 "59e4f23234928137a0a3113f32730de360f9b60950977a9ce6855721e36a567a"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "8cfe83bea17cb597bd39292733a0042fe92da188d3086f34eed122ebcab3fa00" => :high_sierra
    sha256 "8cfe83bea17cb597bd39292733a0042fe92da188d3086f34eed122ebcab3fa00" => :sierra
    sha256 "8cfe83bea17cb597bd39292733a0042fe92da188d3086f34eed122ebcab3fa00" => :el_capitan
    sha256 "8cfe83bea17cb597bd39292733a0042fe92da188d3086f34eed122ebcab3fa00" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.27.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.27.0/darwin/#{arch}/torus"
    end

    getting_started_url = "https://www.torus.sh/docs/latest/start-here/quickstart"
    ohai "Learn how to get started with Torus at #{getting_started_url}!"
  end
end
