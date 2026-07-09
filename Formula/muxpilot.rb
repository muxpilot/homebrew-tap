class Muxpilot < Formula
  desc "Fast tmux workspace picker and agent-aware session menu."
  homepage "https://muxpilot.n.yatsyk.com"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.2/muxpilot-aarch64-apple-darwin.tar.xz"
      sha256 "25e251eab97f6bc366d942b208b838ab7952cc5373d9bea6cd578dc6dbba97bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.2/muxpilot-x86_64-apple-darwin.tar.xz"
      sha256 "df786a6fc8ef5449d9c27c2e8179f9a342c7b13211418ca43ea6f403912c1fcb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.2/muxpilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f766dc3269cbe2618dc1606f1a50c55a51884aa4f20a57add8c1f7f3b77a968e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.2/muxpilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6fea00728f0a109c67661b36ede55a68dd25bb061598a0a3997c90d6805ce393"
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
