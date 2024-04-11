startshape :start

background brightness: -1

shape :start do
  bob hue: 0, saturation: 0.5, brightness: 1
end

shape :bob do
  arm
end

shape :arm do
  triangle size: 1
  triangle size: 0.4, x: 0.28, y: 0.48, rotate: 71, hue: 30, brightness: -0.5
  triangle size: 0.4, x: 0.55, y: 0.0, rotate: 60, hue: -30, brightness: -0.5
  arm rotate: 15.2, size: 0.99, y: 0.9, hue: 50
end
