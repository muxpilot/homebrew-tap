class Muxpilot < Formula
  desc "Fast tmux workspace picker and agent-aware session menu."
  homepage "https://muxpilot.n.yatsyk.com"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.3/muxpilot-aarch64-apple-darwin.tar.xz"
      sha256 "7733a41571db143b91e95fc5d4e292dbf19b95f003b7f18f49f799d7ab345ee1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.3/muxpilot-x86_64-apple-darwin.tar.xz"
      sha256 "8b05dd8a1fba6156ce78ce6c480f4decc391277f85f20107319ba0f91a9e729b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.3/muxpilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d637a0cdd5a28fe385707ce1e36bf0d208ec43191c5c7f2658b8621e00868e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.3/muxpilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "262bc2303bda10494f78f6b1f5828574067504a12039ca77700270861b7c5cc4"
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
