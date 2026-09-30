cask "zeebx" do
  arch arm: "arm64", intel: "x86_64"
  os macos: "macos-#{arch}.dmg", linux: "linux-#{arch}.AppImage"

  version "0.4.1"
  sha256 arm:          "1c1e06087893e38c94a43b449c652d22848aa142cc46997b219f7cdbb5ccc36e",
         intel:        "dc4521a547bc1090ff3f67141eb66a41f11c815102a6f5104bd820672fd8a869",
         x86_64_linux: "cfa1425bd9a460054c6a5da2e747f9f570bc7062771c5c25e376fc180c267ec8"

  on_macos do
    app "Zeebx.app"

    # A mesma pasta do outro cask: o `zap` de um leva as configurações e os saves do outro.
    zap trash: "~/Library/Application Support/Zeebx"

    caveats <<~EOS
      #{token} is not signed by an Apple Developer ID. On first launch, macOS blocks it:
      open System Settings > Privacy & Security and choose "Open Anyway".
    EOS
  end
  on_linux do
    # A release só tem AppImage de x86_64.
    depends_on arch: :x86_64

    app_image "zeebx-standalone-egui-linux-x86_64.AppImage", target: "zeebx.AppImage"

    # A mesma pasta do outro cask: o `zap` de um leva as configurações e os saves do outro.
    zap trash: "~/.config/zeebx"
  end

  url "https://github.com/ZeebxTeam/zeebx-emu/releases/download/v#{version}/zeebx-standalone-egui-#{os}"
  name "Zeebx (egui)"
  desc "Zeebo console emulator, legacy interface"
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
end
