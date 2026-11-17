# TP1 — Format d’image en Julia

Chargement de l’image mandril, extraction des canaux RGB, conversion en niveaux de gris et affichage de trois sous-graphiques.

## Installation

Installer Julia et, dans VS Code, l’extension Julia (`julialang.language-julia`). Dans la console Julia :

```julia
import Pkg
Pkg.add(["Plots", "Images", "TestImages", "FFTW"])
```

## Exécution

Ouvrir `tp1_format_image.jl` dans VS Code et utiliser **Julia: Execute active File in REPL**, ou lancer :

```sh
julia tp1_format_image.jl
```

L’image `mandril_color.tif` est téléchargée automatiquement par [TestImages.jl](https://github.com/JuliaImages/TestImages.jl). Elle n’est pas incluse dans ce dépôt.

## Contenu du TP

1. Format d’image, canaux RGB et affichage.
2. Quantification, transformations de puissance et égalisation d’histogramme.
3. Transformée de Fourier et reconstructions par module ou phase.
4. Sous-échantillonnage et repliement spectral.

Les images `pout.tiff`, `zebra.tiff` et `shirt.tiff` sont téléchargées depuis le site du professeur dans `images/`. Ce serveur n’était pas joignable lors de la préparation : les sections à partir de 2.4 nécessitent ces fichiers et restent à tester. Le téléchargement s’arrête après 30 secondes en cas d’échec.

La formule `ma_quatif` conserve celle du cours : `floor(x * (2^n_bits - 1) / 256)`. Elle n’atteint pas le dernier code ; une quantification par division entière est également fournie pour les 32 niveaux demandés.

Les anciennes sorties Python et PNG sont conservées localement dans `archives/`, hors du dépôt public.
