class Campfire < Formula
  desc "Shared workspace where people and their agents work together"
  homepage "https://github.com/BoringInfraCo/Campfire"
  license "Apache-2.0"
  depends_on "node@22"

  # Same checksummed GitHub Release archives as the curl installer.
  # better-sqlite3 is already compiled inside the archive. The inner
  # bin/campfire wrapper follows symlinks and then execs `node`, so the
  # outer wrapper puts Homebrew's keg-only node@22 on PATH. Install does
  # not start a service and does not report telemetry.
  on_macos do
    on_arm do
      url "https://github.com/BoringInfraCo/Campfire/releases/download/v1.27.0/campfire-darwin-arm64.tar.gz"
      sha256 "b6959a2da7467ef9e3ac62448640271ab32f9c5f614471f4341a08504ed51ffd"
    end
    on_intel do
      url "https://github.com/BoringInfraCo/Campfire/releases/download/v1.27.0/campfire-darwin-x64.tar.gz"
      sha256 "4122da26f8042a05548fd2b598fed611dff16187073470e1fc86cc77242d6669"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BoringInfraCo/Campfire/releases/download/v1.27.0/campfire-linux-arm64.tar.gz"
      sha256 "3d8b28509bf8827ab14555f98fb098ba1b8601c6e280705145f72b44aa9bd8b4"
    end
    on_intel do
      url "https://github.com/BoringInfraCo/Campfire/releases/download/v1.27.0/campfire-linux-x64.tar.gz"
      sha256 "695a3276b39bbe1fdf087f2f9253a56a12364d189bcf4c8982f0f540354dc4c3"
    end
  end

  def install
    libexec.install "bin", "lib"
    (bin/"campfire").write <<~SH
      #!/bin/sh
      export PATH="#{formula_opt_bin("node@22")}:$PATH"
      exec "#{libexec}/bin/campfire" "$@"
    SH
    chmod 0755, bin/"campfire"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/campfire --help")
  end
end
