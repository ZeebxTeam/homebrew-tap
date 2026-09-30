#!/usr/bin/env python3
"""Sobe os casks para a release mais nova do Zeebx.

A escolha é a mesma do atualizador do emulador (`src/ui/atualizacao.rs`): a maior versão que não
é rascunho, **com** pré-lançamentos, porque é assim que as releases saem. O sha256 de cada `.dmg`
vem do campo `digest` da API do GitHub, sem baixar nada. Um cask cuja release não traz os dois
`.dmg` (Apple Silicon e Intel) fica como está: melhor uma versão velha que um cask quebrado.

    python3 .github/scripts/atualiza.py   # reescreve Casks/*.rb; diz o que mudou
"""

import json
import pathlib
import re
import urllib.request

REPOSITORIO = "ZeebxTeam/zeebx-emu"
RAIZ = pathlib.Path(__file__).resolve().parents[2]

# O cask → o prefixo do `.dmg` na release. O sufixo é `-macos-arm64.dmg` ou `-macos-x86_64.dmg`.
CASKS = {
    "zeebx-qt": "zeebx-standalone-qt",
    "zeebx": "zeebx-standalone-egui",
}


def numeros(tag: str) -> tuple[int, ...]:
    nucleo = tag.strip().lstrip("vV").split("-")[0].split("+")[0]
    return tuple(int(p) if p.isdigit() else 0 for p in nucleo.split("."))


def releases() -> list[dict]:
    pedido = urllib.request.Request(
        f"https://api.github.com/repos/{REPOSITORIO}/releases?per_page=20",
        headers={"Accept": "application/vnd.github+json", "User-Agent": "zeebx-homebrew-tap"},
    )
    with urllib.request.urlopen(pedido, timeout=30) as resposta:
        return json.load(resposta)


def atualiza(cask: str, prefixo: str, release: dict) -> bool:
    versao = release["tag_name"].strip().lstrip("vV")
    digests = {a["name"]: a.get("digest") or "" for a in release["assets"]}
    sha = {}
    for arquitetura, sufixo in (("arm", "arm64"), ("intel", "x86_64")):
        digest = digests.get(f"{prefixo}-macos-{sufixo}.dmg", "")
        if not digest.startswith("sha256:"):
            print(f"{cask}: a {versao} não tem {prefixo}-macos-{sufixo}.dmg, fica como está")
            return False
        sha[arquitetura] = digest.removeprefix("sha256:")

    caminho = RAIZ / "Casks" / f"{cask}.rb"
    texto = caminho.read_text(encoding="utf-8")
    novo = re.sub(r'^(  version )"[^"]*"', rf'\g<1>"{versao}"', texto, count=1, flags=re.M)
    novo = re.sub(r'(sha256 arm:\s*)"[0-9a-f]*"', rf'\g<1>"{sha["arm"]}"', novo, count=1)
    novo = re.sub(r'(intel:\s*)"[0-9a-f]*"', rf'\g<1>"{sha["intel"]}"', novo, count=1)
    if novo == texto:
        print(f"{cask}: já está na {versao}")
        return False
    caminho.write_text(novo, encoding="utf-8")
    print(f"{cask}: {versao}")
    return True


def main() -> None:
    candidatas = [r for r in releases() if not r.get("draft")]
    if not candidatas:
        print("nenhuma release publicada")
        return
    release = max(candidatas, key=lambda r: numeros(r["tag_name"]))
    for cask, prefixo in CASKS.items():
        atualiza(cask, prefixo, release)


if __name__ == "__main__":
    main()
