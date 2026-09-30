cask "zeebx" do
  arch arm: "arm64", intel: "x86_64"

  version "0.4.1"
  sha256 arm:   "1c1e06087893e38c94a43b449c652d22848aa142cc46997b219f7cdbb5ccc36e",
         intel: "dc4521a547bc1090ff3f67141eb66a41f11c815102a6f5104bd820672fd8a869"

  url "https://github.com/ZeebxTeam/zeebx-emu/releases/download/v#{version}/zeebx-standalone-egui-macos-#{arch}.dmg"
  name "Zeebx (egui)"
  desc "Zeebo console emulator, legacy interface"
  homepage "https://github.com/ZeebxTeam/zeebx-emu"

  # Ver o comentário no `zeebx-qt.rb`.
  livecheck do
    url :url
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Zeebx.app"

  # A mesma pasta do cask `zeebx-qt`: o `zap` de um leva as configurações e os saves do outro.
  zap trash: "~/Library/Application Support/Zeebx"

  caveats <<~EOS
    #{token} is not signed by an Apple Developer ID. On first launch, macOS blocks it:
    open System Settings > Privacy & Security and choose "Open Anyway".
  EOS
end
