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


# 2 — Quantification
barbara_gray = Gray.(testimage("barbara_color.png"))[10:521, 150:661];
display(plot(barbara_gray, title="Barbara — niveaux de gris"))

data = Float64.(barbara_gray);

# 2.1 — Fonction de quantification (formule du professeur)
function ma_quatif(x::Array{UInt8}, n_bits)
    max = 2^n_bits - 1
    floor.(Float64.(x) .* max ./ 256)
end

# 2.2 — Tester et tracer la fonction sur les 256 valeurs possibles
x = UInt8.(0:255);
ma_quatif(x, 3)
display(plot(x, ma_quatif(x, 3),
    xlabel="Intensité d’entrée (0–255)", ylabel="Code quantifié",
    title="Quantification — 3 bits", label=false))

# Avec la formule du professeur, floor(255 * 7 / 256) = 6.
myimshow(x) = heatmap(x, yflip=true, ratio=1, c=:grays)

# Conversion explicite des intensités normalisées en entiers sur 8 bits.
data = round.(UInt8, Float64.(barbara_gray) .* 255);
display(myimshow(ma_quatif(data, 3)))

# Les exercices suivants utilisent des intensités normalisées dans [0,1].
data = Float64.(barbara_gray);

# 2.2 — Diviser par 8 le nombre de niveaux : 256 / 8 = 32 (5 bits)
barbara_8bit = round.(UInt8, data .* 255);
println("Type des intensités : ", eltype(barbara_8bit))
# Troncature des 3 bits de poids faible : 32 codes, de 0 à 31.
barbara_32 = div.(barbara_8bit, UInt8(8));
p_orig = heatmap(data, yflip=true, ratio=1, c=:grays, clims=(0,1), title="256 niveaux");
p_32 = heatmap(Float64.(barbara_32)./31, yflip=true, ratio=1, c=:grays,
    clims=(0,1), title="32 niveaux — 5 bits");
display(plot(p_orig, p_32, layout=(1,2)))
# UInt8 contient 256 valeurs possibles, de 0 à 255.
# La formule ma_quatif du cours, avec (2^n_bits-1)/256, n’atteint pas
# son dernier code ; div(x,8) donne ici exactement les 32 classes demandées.

# 2.3 — Transformation de puissance, sur des valeurs dans [0,1]
p_15 = heatmap(data.^1.5, yflip=true, ratio=1, c=:grays, clims=(0,1), title="Puissance 1,5");
p_08 = heatmap(data.^0.8, yflip=true, ratio=1, c=:grays, clims=(0,1), title="Puissance 0,8");
display(plot(p_orig, p_15, p_08, layout=(1,3), size=(1200,400)))
# 1,5 assombrit les intensités intermédiaires ; 0,8 les éclaircit.

# Images complémentaires : téléchargées dans le dossier du TP.
using Downloads, FFTW
function charger_image_tp(nom)
    dossier = joinpath(@__DIR__, "images")
    mkpath(dossier)
    chemin = joinpath(dossier, nom)
    if !isfile(chemin)
        Downloads.download("https://www-n.oca.eu/aferrari/data/" * nom, chemin; timeout=30)
    end
    Float64.(Gray.(load(chemin)))
end

# 2.4 — Égalisation d’histogramme par la fonction de répartition cumulée
function egalisation(x)
    codes = round.(UInt8, clamp.(x,0,1).*255)
    h = zeros(Int,256)
    for v in codes
        h[Int(v)+1] += 1
    end
    cdf = cumsum(h)./length(codes)
    image_egalisee = cdf[Int.(codes).+1]
    image_egalisee, cdf
end
pout = charger_image_tp("pout.tiff");
pout_egalisee, transformation = egalisation(pout);
q1 = heatmap(pout, yflip=true, ratio=1, c=:grays, clims=(0,1), title="Pout originale");
q2 = heatmap(pout_egalisee, yflip=true, ratio=1, c=:grays, clims=(0,1), title="Pout égalisée");
q3 = plot(0:255, transformation, xlabel="Intensité initiale", ylabel="Intensité finale", label=false, title="Transformation cumulée");
q4 = histogram(vec(pout), bins=0:1/256:1, label=false, title="Histogramme initial");
q5 = histogram(vec(pout_egalisee), bins=0:1/256:1, label=false, title="Histogramme égalisé");
display(plot(q1,q2,q3,q4,q5,layout=(2,3),size=(1200,750)))
# La transformation est croissante et étale le contraste ; un histogramme
# discret égalisé n’est pas nécessairement parfaitement uniforme.

# 3 — Transformée de Fourier
function afficher_tfd(image, titre)
    spectre = fftshift(fft(image))
    a = heatmap(image, yflip=true, ratio=1, c=:grays, title=titre)
    b = heatmap(log.(1 .+ abs.(spectre)), yflip=true, ratio=1,
        c=:grays, title="log(1 + module TFD), centrée")
    display(plot(a,b,layout=(1,2),size=(1000,450)))
end
# 3.1 — x(k,l) = sin(2π × 0,07 × l), taille 256 × 256
sinusoide = [sin(2*pi*0.07*l) for k in 0:255, l in 0:255];
afficher_tfd(sinusoide,"Sinusoïde")
# Deux pics autour des fréquences ±0,07 cycle/pixel ; la fréquence
# n’est pas un multiple de 1/256, d’où une fuite spectrale.

# 3.2 — TFD de Zebra et Barbara
zebra = charger_image_tp("zebra.tiff");
afficher_tfd(zebra,"Zebra")
afficher_tfd(data,"Barbara")

# 3.3 — TFD inverse du module seul (phase nulle)
F_barbara = fft(data);
barbara_module = real.(ifft(abs.(F_barbara)));
# 3.4 — TFD inverse de la phase seule (module unitaire)
barbara_phase = real.(ifft(exp.(im .* angle.(F_barbara))));
r1 = heatmap(barbara_module, yflip=true, ratio=1, c=:grays, title="Module seul — phase nulle");
r2 = heatmap(barbara_phase, yflip=true, ratio=1, c=:grays, title="Phase seule — module 1");
display(plot(r1,r2,layout=(1,2),size=(1000,450)))
# La phase porte une grande part de l’organisation spatiale de l’image.
# Les reconstructions sont affichées avec une échelle de contraste automatique.

# 4 — Repliement spectral
# 4.1 — Shirt sous-échantillonnée d’un facteur 4, sans filtrage préalable
shirt = charger_image_tp("shirt.tiff");
shirt_4 = shirt[1:4:end,1:4:end];
s1 = heatmap(shirt,yflip=true,ratio=1,c=:grays,title="Shirt originale");
s2 = heatmap(shirt_4,yflip=true,ratio=1,c=:grays,title="Shirt — facteur 4");
display(plot(s1,s2,layout=(1,2),size=(1000,450)))
# Les motifs fins dépassant la nouvelle fréquence de Nyquist (1/8
# cycle par pixel original) se replient : faux motifs / moiré.
# Un filtre passe-bas avant décimation limite ce phénomène.

# 4.2 — Même sous-échantillonnage pour Barbara
barbara_4 = data[1:4:end,1:4:end];
s3 = heatmap(data,yflip=true,ratio=1,c=:grays,title="Barbara originale");
s4 = heatmap(barbara_4,yflip=true,ratio=1,c=:grays,title="Barbara — facteur 4");
display(plot(s3,s4,layout=(1,2),size=(1000,450)))
# Les tissus et rayures peuvent présenter du repliement spectral.
