startshape :ancient_map

background brightness: -0.1, saturation: 0.25, hue: 44
minsize 0.05

shape :ancient_map do
  wall brightness: 0.1, hue: 34
  wall brightness: 0.1, rotate: 180, hue: 34
end

shape :wall

rule do
  wall y: 0.95, rotate: 1, size: 0.975
end

rule do
  square
  wall y: 0.95, rotate: -1, size: 0.975, saturation: 0.1, brightness: 0.01, hue: 0.1
end

rule 0.09 do
  square
  wall y: 0.95, rotate: 90, size: 0.975
  wall y: 0.95, rotate: -90, size: 0.975
end

rule 0.005 do
  wall y: 0.97, rotate: 90, size: 1.5
  wall y: 0.97, rotate: -90, size: 1.5
end
