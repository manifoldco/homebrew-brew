require "language/go"

class Torus < Formula
  desc "A secure, shared workspace for secrets"
  homepage "https://www.torus.sh"
  url "https://github.com/manifoldco/torus-cli/archive/v0.15.0.tar.gz"
  sha256 "b516791d6bb6611e07c5e8a663522ed06874ff4588831dfef04af1b879bee195"
  head "https://github.com/manifoldco/torus-cli.git"

  depends_on "go" => :build

go_resource "github.com/asaskevich/govalidator" do
  url "https://github.com/asaskevich/govalidator", :using => :git, :revision => "593d64559f7600f29581a3ee42177f5dbded27a9"
end

go_resource "github.com/boltdb/bolt" do
  url "https://github.com/boltdb/bolt", :using => :git, :revision => "583e8937c61f1af6513608ccc75c97b6abdf4ff9"
end

go_resource "github.com/BurntSushi/toml" do
  url "https://github.com/BurntSushi/toml", :using => :git, :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
end

go_resource "github.com/chzyer/readline" do
  url "https://github.com/chzyer/readline", :using => :git, :revision => "bc5c91eb5bc99e662b22bfaa6b84ddc56b70eccc"
end

go_resource "github.com/dchest/blake2b" do
  url "https://github.com/dchest/blake2b", :using => :git, :revision => "3c8c640cd7bea3ca78209d812b5854442ab92fed"
end

go_resource "github.com/donovanhide/eventsource" do
  url "https://github.com/donovanhide/eventsource", :using => :git, :revision => "fd1de70867126402be23c306e1ce32828455d85b"
end

go_resource "github.com/facebookgo/clock" do
  url "https://github.com/facebookgo/clock", :using => :git, :revision => "600d898af40aa09a7a93ecb9265d87b0504b6f03"
end

go_resource "github.com/facebookgo/httpdown" do
  url "https://github.com/facebookgo/httpdown", :using => :git, :revision => "a3b1354551a26449fbe05f5d855937f6e7acbd71"
end

go_resource "github.com/facebookgo/stats" do
  url "https://github.com/facebookgo/stats", :using => :git, :revision => "1b76add642e42c6ffba7211ad7b3939ce654526e"
end

go_resource "github.com/go-ini/ini" do
  url "https://github.com/go-ini/ini", :using => :git, :revision => "3e15c6754352225de49767249c3680a2fa2201f5"
end

go_resource "github.com/go-zoo/bone" do
  url "https://github.com/go-zoo/bone", :using => :git, :revision => "0237f0c5455f175a6513e21afe050e128902dc7f"
end

go_resource "github.com/gorilla/context" do
  url "https://github.com/gorilla/context", :using => :git, :revision => "08b5f424b9271eedf6f9f0ce86cb9396ed337a42"
end

go_resource "github.com/gorilla/mux" do
  url "https://github.com/gorilla/mux", :using => :git, :revision => "cf79e51a62d8219d52060dfc1b4e810414ba2d15"
end

go_resource "github.com/julienschmidt/httprouter" do
  url "https://github.com/julienschmidt/httprouter", :using => :git, :revision => "d8ff598a019f2c7bad0980917a588193cf26666e"
end

go_resource "github.com/kardianos/osext" do
  url "https://github.com/kardianos/osext", :using => :git, :revision => "c2c54e542fb797ad986b31721e1baedf214ca413"
end

go_resource "github.com/keybase/go-triplesec" do
  url "https://github.com/keybase/go-triplesec", :using => :git, :revision => "b360b8252869a5ac88df3ed7897bc3b6d1e55dd2"
end

go_resource "github.com/kr/pty" do
  url "https://github.com/kr/pty", :using => :git, :revision => "ce7fa45920dc37a92de8377972e52bc55ffa8d57"
end

go_resource "github.com/kr/text" do
  url "https://github.com/kr/text", :using => :git, :revision => "7cafcd837844e784b526369c9bce262804aebc60"
end

go_resource "github.com/natefinch/lumberjack" do
  url "https://github.com/natefinch/lumberjack", :using => :git, :revision => "e21e5cbec0cd0861b9dc302736ad5666c529d93f"
end

go_resource "github.com/nbutton23/zxcvbn-go" do
  url "https://github.com/nbutton23/zxcvbn-go", :using => :git, :revision => "a22cb81b2ecdde8b68e9ffb8824731cbf88e1de4"
end

go_resource "github.com/nightlyone/lockfile" do
  url "https://github.com/nightlyone/lockfile", :using => :git, :revision => "3d299f51e376213fcdcfd213a76afce6b290bf9d"
end

go_resource "github.com/satori/go.uuid" do
  url "https://github.com/satori/go.uuid", :using => :git, :revision => "0aa62d5ddceb50dbcb909d790b5345affd3669b6"
end

go_resource "github.com/urfave/cli" do
  url "https://github.com/urfave/cli", :using => :git, :revision => "207bb6185291cfced4895a7768cad642e08a68d8"
end

go_resource "golang.org/x/crypto" do
  url "https://go.googlesource.com/crypto", :using => :git, :revision => "b35ccbc95a0eaae49fb65c5d627cb7149ed8d1ab"
end

go_resource "golang.org/x/net" do
  url "https://go.googlesource.com/net", :using => :git, :revision => "7394c112eae4dba7e96bfcfe738e6373d61772b4"
end

go_resource "golang.org/x/sys" do
  url "https://go.googlesource.com/sys", :using => :git, :revision => "a646d33e2ee3172a661fc09bca23bb4889a41bc8"
end

go_resource "gopkg.in/oleiade/reflections.v1" do
  url "https://gopkg.in/oleiade/reflections.v1", :using => :git, :revision => "2b6ec3da648e3e834dc41bad8d9ed7f2dc6a9496"
end

go_resource "gopkg.in/yaml.v2" do
  url "https://gopkg.in/yaml.v2", :using => :git, :revision => "e4d366fc3c7938e2958e662b4258c7a89e1f0e3e"
end


  def install
    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", buildpath

    toruspath = buildpath/"src/github.com/manifoldco/torus"
    toruspath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd toruspath do
      ENV.deparallelize { system "make" }

      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "make", "binary-darwin-#{arch}"

      bin.install "builds/bin/0.15.0/darwin/#{arch}/torus"
    end
  end
end
