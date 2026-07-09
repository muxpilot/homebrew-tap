class Muxpilot < Formula
  desc "Fast tmux workspace picker and agent-aware session menu."
  homepage "https://muxpilot.n.yatsyk.com"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.1/muxpilot-aarch64-apple-darwin.tar.xz"
      sha256 "a09f140f526828d9569e096dd47e8600c8bac32d143031f739ef709079de48d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.1/muxpilot-x86_64-apple-darwin.tar.xz"
      sha256 "4639d7cd6ef41fc6170364714c1b136bdd3e4beddc592f79aa0d8c75fd71c50d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.1/muxpilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "04b9b03e91f5f95e2d7435d11b2ce2215766ee181c1a0b14d0ed2068e5df61ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/muxpilot/muxpilot/releases/download/v0.1.1/muxpilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "892de283768ea5ac035a771738ded300a02a6c26d9a9c0ec720649808900bb1f"
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
