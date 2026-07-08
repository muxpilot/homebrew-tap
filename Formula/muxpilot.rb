class Muxpilot < Formula
  desc "Fast tmux workspace picker and agent-aware session menu."
  homepage "https://muxpilot.n.yatsyk.com"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.0/muxpilot-aarch64-apple-darwin.tar.xz"
      sha256 "e266ace984c9c4f4c8d7db8f52e2e6af8d8a2dc1609ca15debbab8d02798da0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.0/muxpilot-x86_64-apple-darwin.tar.xz"
      sha256 "f919713c8bdfa0ea0d8fbd81598449627a52482f8861a00129131e2c5acdba60"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.0/muxpilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fbdc12251f732132224d4bb79c36934efe6998a6a052fdeca2941db27b7f5108"
    end
    if Hardware::CPU.intel?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.0/muxpilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef9b29cc8acbeddba4707d834ecd3b16a9c49c1d9080acea0a569e2ded92106e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "muxpilot" if OS.mac? && Hardware::CPU.arm?
    bin.install "muxpilot" if OS.mac? && Hardware::CPU.intel?
    bin.install "muxpilot" if OS.linux? && Hardware::CPU.arm?
    bin.install "muxpilot" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
