class ZuulSecrets < Formula
  desc "CLI tool for managing secrets across multiple environments, backed by pluggable cloud secret managers"
  homepage "https://github.com/farmisen/zuul"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/farmisen/zuul/releases/download/v0.1.1/zuul-secrets-aarch64-apple-darwin.tar.xz"
      sha256 "0bfc34a24d84540ad35f6965dedff137294e8b3560cc4d01f8ccb29a81b7c1d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/farmisen/zuul/releases/download/v0.1.1/zuul-secrets-x86_64-apple-darwin.tar.xz"
      sha256 "b410556a92611090324168b51872620aba10ded82e4b9e48a5f2d97c8b2a16ad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/farmisen/zuul/releases/download/v0.1.1/zuul-secrets-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "165264a5b9eb5491bcadd8607e918961a747116bd67e1e44fc2bf6c7336fa05c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/farmisen/zuul/releases/download/v0.1.1/zuul-secrets-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "794982840142455bbc1a973c2e667efff388aaea4ba7fa7ece7bee8f60728e65"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "zuul" if OS.mac? && Hardware::CPU.arm?
    bin.install "zuul" if OS.mac? && Hardware::CPU.intel?
    bin.install "zuul" if OS.linux? && Hardware::CPU.arm?
    bin.install "zuul" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
