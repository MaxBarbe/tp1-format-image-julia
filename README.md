# TP1 — Format d’image en Julia

Chargement de l’image mandril, extraction des canaux RGB, conversion en niveaux de gris et affichage de trois sous-graphiques.

## Installation

Installer Julia et, dans VS Code, l’extension Julia (`julialang.language-julia`). Dans la console Julia :

```julia
import Pkg
Pkg.add(["Plots", "Images", "TestImages"])
```

## Exécution

Ouvrir `tp1_format_image.jl` dans VS Code et utiliser **Julia: Execute active File in REPL**, ou lancer :

```sh
julia tp1_format_image.jl
```

L’image `mandril_color.tif` est téléchargée automatiquement par [TestImages.jl](https://github.com/JuliaImages/TestImages.jl). Elle n’est pas incluse dans ce dépôt.
