# Zeebx Homebrew tap

Homebrew casks for [Zeebx](https://github.com/ZeebxTeam/zeebx-emu), the Zeebo console emulator.

```bash
brew install --cask zeebxteam/tap/zeebx-qt   # the main interface (macOS 13+)
brew install --cask zeebxteam/tap/zeebx      # the legacy egui interface (macOS 11+)
```

Zeebx is not signed by an Apple Developer ID yet. On first launch macOS blocks it: open
**System Settings → Privacy & Security** and choose **Open Anyway**.

The emulator updates itself, so `brew upgrade` leaves it alone unless you pass `--greedy`.

---

## Como este tap funciona

- `Casks/zeebx-qt.rb` e `Casks/zeebx.rb` apontam para os `.dmg` da release do Zeebx, um por
  arquitetura (`arm64` e `x86_64`).
- O workflow `atualiza.yml` roda todo dia (e à mão, pela aba Actions): o
  `.github/scripts/atualiza.py` acha a release mais nova — com pré-lançamentos, como o emulador — e
  sobe a versão e os sha256, lidos da API do GitHub. Depois o `brew style` e o `brew audit` conferem
  os casks, e o bot commita.
- Por que não o repositório oficial (`homebrew/cask`): desde o Homebrew 5, casks que não passam no
  Gatekeeper — sem assinatura Developer ID e notarização — foram desativados em 01/09/2026. Um tap
  próprio não tem essa exigência.
