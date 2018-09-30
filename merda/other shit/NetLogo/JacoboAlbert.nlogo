breed [humans huma]
breed [hunters hunter]
breed [zombies zombie]
breed [marques marca]
breed [lapides lapida]
patches-own [menjar temporitzadorMenjar]
turtles-own [vida velocitat gana]



to setup
  clear-all
  set-default-shape marques "marcamort"
  set-default-shape lapides "lapida"
  initHumans
  initHunters
  initZombies
  initMenjar
  reset-ticks
end

to go
  if (count humans > 0 or count hunters > 0)
  [
    ask zombies [
      zMorir
      escollirObjectiuZombie
      anarAPerHuma
      matarHuma
      set vida vida - 0.5
    ]
  ]


  if (count zombies > 0 )
  [
    ask humans[
      morirDeGana
      morirPerZombie
      escollirObjectiuHuma
      humans-menjar
      set gana gana - 0.5
    ]
  ]

  if (count zombies > 0 )
  [
    ask hunters[
      morirPerZombie
      escollirObjectiuHunter
      anarAPerZombie
      matarZombie
    ]
  ]


  ask patches [creixerMenjar]
  tick
end

to escollirObjectiuHuma
  anarAPerMenjar
end


to escollirObjectiuHunter
  ifelse (count zombies > 0)
    [let nearest-zombie min-one-of zombies [distance myself]
     let dist-nearest-zombie distance nearest-zombie
     ifelse (dist-nearest-zombie < 150)
      [zombieVist]
      [seguirBuscant]
    ]
    [seguirBuscant]
end

to escollirObjectiuZombie

  ifelse (count humans > 0 or count hunters > 0)
    [let humaMesProper min-one-of humans [distance myself]
     let caçadorMesProper min-one-of hunters [distance myself]
      let dist-humaMesProper 100000
      let dist-caçadorMesProper  100000
     if (humaMesProper != nobody)
      [set dist-humaMesProper distance humaMesProper]
     if (caçadorMesProper != nobody)
      [set dist-caçadorMesProper distance caçadorMesProper]
     ifelse (dist-humaMesProper <= dist-caçadorMesProper)
      [let dist-mesProper dist-humaMesProper
      ifelse (dist-mesProper < rangVistaZombies)
        [humaVist]
        [seguirBuscant]]
      [let dist-mesProper dist-caçadorMesProper
       ifelse (dist-mesProper < rangVistaZombies)
        [caçadorVist]
        [seguirBuscant]]
  ]
    [seguirBuscant]

end

to humaVist
  face min-one-of humans [distance myself]
end

to caçadorVist
  face min-one-of hunters [distance myself]
end

to zombieVist
  face min-one-of zombies [distance myself]
end

to seguirBuscant
  rt random-float 70
  lt random-float 70

end

to anarAPerHuma
  fd velocitat
end

to anarAPerZombie
  fd velocitat
end


to matarHuma
  let matat false
  let prey one-of humans-here
  if (prey != nobody)
      [ask prey [set vida vida - 10]
        set vida vida + 10
      set matat true
  ]

if matat = false[
  let prey2 one-of hunters-here
  if (prey2 != nobody)
    [ask prey2 [set vida vida - 40]
      set vida vida + 10]
  ]
end

to matarZombie
  let prey one-of zombies in-radius rangAtacCaçadors
  if (prey != nobody)
    [ask prey [set vida vida - 30]
     ]
end

to morirPerZombie
  if vida <= 0
    [set breed zombies
     set size 6
     set vida 150]
end

to morirDeGana
  if gana <= 0
    [set breed lapides
     set size 6]
end

to zMorir
  if vida <= 0
     [set breed marques
      set size 5]
end

to anarAPerMenjar
  if (count patches with [menjar > 1] > 0)[
    face min-one-of patches with [menjar > 1] [distance myself]
    ifelse (menjarMesProper < velocitat)
    [fd menjarMesProper]
    [fd velocitat]
  ]
end

to humans-menjar
  if (menjar > 1)
  [ask patch-here [
    set menjar 1
    set pcolor 32
    ]
    set gana gana + 20
  ]
end

to initHumans
  set-default-shape humans "person farmer"
  create-humans persones
  [
    set size 6
    setxy random-xcor random-ycor
    set velocitat velocitatHumans
    set vida 100
    set gana 30
  ]
end

to initHunters
  set-default-shape hunters "hunter"
  create-hunters caçadors
  [
    set velocitat velocitatHumans
    setxy random-xcor random-ycor
    set vida 200
    set size 7
  ]
end

to initZombies
  set-default-shape zombies "fzombie"
  create-zombies convertits
  [
    set size 7
    set color green
    set velocitat velocitatZombies
    set vida vidaZombies
    setxy random-xcor random-ycor
  ]
end

to initMenjar
  ask patches [set pcolor 32]
  ask patches [
    if (abs random-normal 0 1 > 2.8)
      [set pcolor 63
       set menjar 2]
  ]
end

to creixerMenjar
  if menjar = 1 [
    ifelse temporitzadorMenjar <= 0
      [ set pcolor 63
        set menjar 2
        set temporitzadorMenjar tempsRespawnMenjar ]
      [ set temporitzadorMenjar temporitzadorMenjar - 1 ]
  ]
end

to-report menjarMesProper
  ifelse (count patches with [menjar > 1] > 0)
  [report distance min-one-of patches with [menjar > 1] [distance myself]]
  [report -1]
end
@#$#@#$#@
GRAPHICS-WINDOW
173
52
1276
525
-1
-1
7.252
1
10
1
1
1
0
0
0
1
0
150
0
63
1
1
1
ticks
30.0

BUTTON
2
12
65
45
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
81
11
144
44
go
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

SLIDER
0
53
172
86
persones
persones
1
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
1
168
175
201
TempsRespawnMenjar
TempsRespawnMenjar
20
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
2
209
174
242
velocitatHumans
velocitatHumans
0.1
5
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
2
250
174
283
velocitatZombies
velocitatZombies
0.1
3
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
2
290
174
323
rangAtacCaçadors
rangAtacCaçadors
1
10
9.0
1
1
NIL
HORIZONTAL

SLIDER
1
93
173
126
convertits
convertits
1
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
2
331
174
364
vidaZombies
vidaZombies
10
100
100.0
1
1
NIL
HORIZONTAL

PLOT
1280
51
1866
529
Poblacio
time
pop
0.0
18.0
0.0
18.0
true
true
"" ""
PENS
"Humans" 1.0 0 -13791810 true "" "plot count humans"
"Zombies" 1.0 0 -2674135 true "" "plot count zombies"
"Hunters" 1.0 0 -6459832 true "" "plot count hunters"

SLIDER
1
130
173
163
caçadors
caçadors
1
5
3.0
1
1
NIL
HORIZONTAL

SLIDER
1
370
173
403
rangVistaZombies
rangVistaZombies
5
100
62.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

La simulació consisteix en un apocalipsis zombie. En l'apocalipsis tenim farmers, hunters i zombies. Qui serà l'ultim en quedar viu? SIMULEM-HO!

## HOW IT WORKS

3 tipus d'agents principals:

F A R M E R S

Aquests el seu objectiu es no morir de gana per lo que aniran buscant menjant que es genera pel mapa. Si un zombie els ataca i els mata es convertiren en zombies. Si no troben menjar i es moren de gana es convertiren en un làpida.

H U N T E R S

El objectiu dels hunters es anar a per els zombies. Aquests si un zombie els ataca es converitan en zombies. A diferència dels Farmers aquets no poden morir de gana.

Z O M B I E S

El objectiu d'aquests es matar a farmers i hunters. Aniran en busca de hunters i farmes, si no hi ha ningun en el seu radi de cerca es mouran aleatoriament. Si passat un temps no maten a ningú aquests moriran i es convertirán en calaveres.

1 PATCH: 

M E N J A R

Aquest patch surt aleatoriament repartit pel mapa i quan un farmer se'l "menja" aquest tarda un temps en apareixer.

## HOW TO USE IT

Amb els diferents sliders es pot variar la quantitat de persones com de hunter i de zombies. També el rang dels hunters, temps de "respawn" del menjar, velocitat, vida i rang de cerca dels zombies.

## THINGS TO NOTICE

No tinguis por és una simulació, no hi ha ningun atac zombie... de moment...

## THINGS TO TRY

Amb els diferents sliders podràs fer que guanyi el teu preferit o una batalla campal, fica'ls a la màxima velocitat i veuràs una ràpida massacre.

## EXTENDING THE MODEL

Els hunters disparen i tenen un rang però no hem implementat que gràficament es vegi el dispar, podría ser una millora grafica molt bona. Els farmes son bastant bàsics i només pensen en menjar... si els hi ve un zombie no escaparan d'ell.


## CREDITS AND REFERENCES

Simulació realitzada per Albert Figuera Pérez i Jacobo Moral Buendía per a l'assignatura de Simulació de la Facultat d'Informàtica de Barcelona.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

fzombie
false
1
Circle -13840069 true false 125 5 80
Rectangle -13840069 true false 127 79 172 94
Polygon -13840069 true false 195 90 240 150 225 180 165 105
Polygon -13840069 true false 105 90 60 150 75 180 135 105
Polygon -6459832 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -2674135 true true 150 30 165 45
Rectangle -2674135 true true 180 30 195 45
Rectangle -2674135 true true 165 30 165 30
Rectangle -2674135 false true 150 105 165 180
Rectangle -2674135 false true 150 105 165 180
Rectangle -13840069 true false 150 105 165 180
Rectangle -13840069 true false 120 240 135 255
Rectangle -13840069 true false 165 225 180 285
Rectangle -10899396 true false 105 105 135 120
Rectangle -10899396 true false 120 195 180 210
Rectangle -10899396 true false 105 255 135 285
Rectangle -10899396 true false 120 135 150 165
Rectangle -2674135 true true 180 105 195 105

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

hunter
false
1
Rectangle -955883 true false 127 79 172 94
Polygon -955883 true false 105 90 60 195 90 210 135 105
Polygon -955883 true false 195 90 240 195 210 210 165 105
Circle -955883 true false 110 5 80
Polygon -6459832 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -16777216 true false 120 90 105 90 180 195 180 165
Line -16777216 false 109 105 139 105
Line -16777216 false 122 125 151 117
Line -16777216 false 137 143 159 134
Line -16777216 false 158 179 181 158
Line -16777216 false 146 160 169 146
Rectangle -16777216 true false 120 193 180 201
Polygon -14835848 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -16777216 true false 114 187 128 208
Rectangle -16777216 true false 177 187 191 208
Rectangle -7500403 true false 225 165 240 210
Rectangle -7500403 true false 225 150 285 180
Line -7500403 false 255 180 225 195
Rectangle -16777216 true false 270 150 285 165

lapida
true
7
Circle -7500403 true false 90 30 120
Rectangle -7500403 true false 90 90 210 240
Line -16777216 false 120 75 120 120
Line -16777216 false 120 75 135 90
Line -16777216 false 120 105 135 90
Line -16777216 false 120 105 135 120
Line -16777216 false 150 75 150 120
Line -16777216 false 165 75 165 120
Line -16777216 false 165 75 180 90
Line -16777216 false 165 105 180 90
Line -16777216 false 150 150 150 225
Line -16777216 false 135 165 165 165

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

marcamort
true
8
Circle -7500403 false false 60 45 180
Rectangle -7500403 false false 135 210 165 210
Circle -1 true false 60 45 180
Rectangle -7500403 true false 105 180 195 240
Rectangle -1 false false 105 195 135 240
Rectangle -16777216 false false 135 195 195 240
Rectangle -16777216 false false 135 195 165 240
Rectangle -1 true false 105 180 195 240
Rectangle -16777216 false false 105 195 135 240
Rectangle -16777216 false false 135 195 195 240
Rectangle -16777216 false false 135 195 165 240
Circle -16777216 true false 99 99 42
Circle -16777216 true false 159 99 42
Line -16777216 false 150 150 135 180
Line -16777216 false 135 180 165 180
Line -16777216 false 150 150 165 180

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person farmer
false
2
Polygon -955883 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -955883 true true 110 5 80
Rectangle -955883 true true 127 79 172 94
Polygon -13345367 true false 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -6459832 true false 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Line -16777216 false 225 90 270 90
Line -16777216 false 225 15 225 90
Line -16777216 false 270 15 270 90
Line -16777216 false 247 15 247 90
Rectangle -6459832 true false 240 90 255 300
Circle -16777216 true false 135 45 0
Circle -16777216 true false 135 45 0

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
