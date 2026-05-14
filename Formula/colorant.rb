class Colorant < Formula
  desc "Per-directory terminal theme switcher with system dark/light mode support"
  homepage "https://github.com/farmisen/colorant"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/farmisen/colorant/releases/download/v0.4.0/colorant-aarch64-apple-darwin.tar.xz"
      sha256 "6e91ab5a9351e3a3cf2139a089cd26620de6c0a35d382eced5600a276fd4aa14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/farmisen/colorant/releases/download/v0.4.0/colorant-x86_64-apple-darwin.tar.xz"
      sha256 "afb6128f50a8ee713a4602fb9488c73e24b7f7aaef791e0b5608deee0b0124c3"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "colorant" if OS.mac? && Hardware::CPU.arm?
    bin.install "colorant" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
