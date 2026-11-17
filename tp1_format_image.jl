# TP1 — Partie 1 : format d’image (Julia)
# À exécuter dans Julia, comme au cours.
# Si nécessaire, installer une seule fois dans la console Julia :
# import Pkg; Pkg.add(["Plots", "Images", "TestImages"])

using Plots, Images, TestImages

# 1.1 — Charger l’image couleur et observer son type
mandril_color = testimage("mandril_color.tif");
typeof(mandril_color)
println("Type de l’image : ", typeof(mandril_color))
println("Type d’un pixel : ", eltype(mandril_color))
println("Dimensions : ", size(mandril_color))


# Matrix{RGB{N0f8}} : matrice de pixels RGB ; chaque canal est
# représenté sur 8 bits, avec des valeurs normalisées entre 0 et 1.
mandril_array_green = green.(mandril_color)*255;
mandril_array_red = red.(mandril_color)*255;
mandril_array_blue = blue.(mandril_color)*255;

#println("green : ", mandril_array_green )
#println("red : ", mandril_array_red )
#println("blue : ", mandril_array_blue )


# 1.2 — Convertir en niveaux de gris, puis en matrice Float64
mandril_gray = Gray.(mandril_color);
mandril_array = Float64.(mandril_gray);
println("Type en niveaux de gris : ", typeof(mandril_gray))
println("Type du tableau : ", typeof(mandril_array))
println("Intensités min / max : ", extrema(mandril_array))

# 1.3 — Afficher les images dans une seule figure (sous-graphiques)
data = mandril_array;
p1 = plot(mandril_color, title="Originale");
p2 = heatmap(data, yflip = true, ratio=1, c= :grays, title="Gris");

# Pour changer l’intensité
p3 = heatmap(data, yflip = true, ratio=1, c= :grays,
    clim = (0.2, maximum(data)), title="Gris — contraste ajusté");

display(plot(p1, p2, p3, layout=(1, 3), size=(1200, 400)))
