cask "zeebx-qt" do
  arch arm: "arm64", intel: "x86_64"

  version "0.4.1"
  sha256 arm:   "6a0f26f5aa79e4e8e9d113cf7ed7315021085705315ed4cc3a9295d147db31c2",
         intel: "47c7e3de67c43cdb3fa9069c3962d077bae5caae425fb111e7e141528a51a9ed"

  url "https://github.com/ZeebxTeam/zeebx-emu/releases/download/v#{version}/zeebx-standalone-qt-macos-#{arch}.dmg"
  name "Zeebx"
  desc "Zeebo console emulator"
  homepage "https://github.com/ZeebxTeam/zeebx-emu"

  # As releases saem como pré-lançamento, e a estratégia de releases do GitHub as ignora: as tags
  # não. Quem mantém o tap em dia é o workflow `atualiza.yml`, não o livecheck.
  livecheck do
    url :url
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  # O emulador se atualiza sozinho (ver `src/ui/atualizacao.rs` no repositório dele): o
  # `brew upgrade` só mexe nele com `--greedy`.
  auto_updates true
  # O Qt 6.11 do pacote pede o macOS 13.
  depends_on macos: ">= :ventura"

  app "Zeebx Qt.app"

  # A mesma pasta do cask `zeebx`: o `zap` de um leva as configurações e os saves do outro.
  zap trash: "~/Library/Application Support/Zeebx"

  caveats <<~EOS
    #{token} is not signed by an Apple Developer ID. On first launch, macOS blocks it:
    open System Settings > Privacy & Security and choose "Open Anyway".
  EOS
end
