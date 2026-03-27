class ZuulSecrets < Formula
  desc "CLI tool for managing secrets across multiple environments, backed by pluggable cloud secret managers"
  homepage "https://github.com/farmisen/zuul"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/farmisen/zuul/releases/download/v0.1.0/zuul-secrets-aarch64-apple-darwin.tar.xz"
      sha256 "c242f41d5a0edb86d375b9a41ce6764e780c6afc238ed599f8bab4635d12121b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/farmisen/zuul/releases/download/v0.1.0/zuul-secrets-x86_64-apple-darwin.tar.xz"
      sha256 "4d7437cb52a72a3b305f9af742357249b2c82693e2c6d51766efba08690b9895"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/farmisen/zuul/releases/download/v0.1.0/zuul-secrets-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eddd34b5b5b5f29981b4b423b60cdef93aebba5af4f7c4037aa5fe70930bc27b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/farmisen/zuul/releases/download/v0.1.0/zuul-secrets-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b3e8461d7008a888bd6d5725830e78cc9b825b50278bb4923af0da4498bcc78f"
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
