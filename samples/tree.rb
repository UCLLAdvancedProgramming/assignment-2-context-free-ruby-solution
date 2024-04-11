startshape :seed

minsize 0.1

shape :seed

rule do
  square
  seed y: 1, size: 0.99, rotate: 1.5
end

rule 0.05 do
  seed size: [-1, 1]
end

rule 0.05 do
  square
  seed y: 1, size: [-0.95, 0.95], rotate: 1.5, brightness: -0.7
  seed y: 1, x: 1, size: 0.6, rotate: -40, brightness: -0.7
  seed y: 1, x: -1, size: [-0.5, 0.5], rotate: 40, brightness: -0.7
end
