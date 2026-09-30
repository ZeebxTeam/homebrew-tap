# Zeebx Homebrew tap

Homebrew casks for [Zeebx](https://github.com/ZeebxTeam/zeebx-emu), the Zeebo console emulator.

```bash
brew install --cask zeebxteam/tap/zeebx-qt   # the main interface
brew install --cask zeebxteam/tap/zeebx      # the legacy egui interface
```

- **macOS** (13+ for `zeebx-qt`): installs the `.app` into `/Applications`. Zeebx is not signed by
  an Apple Developer ID yet, so on first launch macOS blocks it: open **System Settings → Privacy &
  Security** and choose **Open Anyway**.
- **Linux** (x86_64, Homebrew 6+): installs the AppImage as `~/Applications/zeebx-qt.AppImage`
  (or `zeebx.AppImage`). Homebrew does not add a menu entry; run it from there.

The emulator updates itself, so `brew upgrade` leaves it alone unless you pass `--greedy`.

---

## Como este tap funciona

- `Casks/zeebx-qt.rb` e `Casks/zeebx.rb` apontam para os pacotes da release do Zeebx: no macOS o
  `.dmg` de cada arquitetura (`arm64` e `x86_64`), no Linux o AppImage de x86_64 (casks com
  AppImage existem desde o Homebrew 6.0).
- O workflow `atualiza.yml` roda todo dia (e à mão, pela aba Actions): o
  `.github/scripts/atualiza.py` acha a release mais nova — com pré-lançamentos, como o emulador — e
  sobe a versão e os sha256, lidos da API do GitHub. Depois o `brew style` e o `brew audit` conferem
  os casks no macOS e no Linux, e o bot commita.
- Por que não o repositório oficial (`homebrew/cask`): desde o Homebrew 5, casks que não passam no
  Gatekeeper — sem assinatura Developer ID e notarização — foram desativados em 01/09/2026. Um tap
  próprio não tem essa exigência.
