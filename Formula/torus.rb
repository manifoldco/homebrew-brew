require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.22.0.tar.gz"
  sha256 "85dc254d977755241a0202e192da729c255d19fb6b549bb604a22a1c5e1b3d69"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  bottle do
    root_url "https://get.torus.sh/brew/bottles"
    cellar :any_skip_relocation
    sha256 "c50fd3e6f8b8927d7532a923f4413b4a100211e008290ad19b8d00654d8747c7" => :sierra
    sha256 "c50fd3e6f8b8927d7532a923f4413b4a100211e008290ad19b8d00654d8747c7" => :el_capitan
    sha256 "c50fd3e6f8b8927d7532a923f4413b4a100211e008290ad19b8d00654d8747c7" => :yosemite
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
        system "make", "binary-darwin-#{arch}", "VERSION=0.22.0", "BYPASS_GO_CHECK=yes"
      end

      bin.install "builds/bin/0.22.0/darwin/#{arch}/torus"
    end
  end
end
