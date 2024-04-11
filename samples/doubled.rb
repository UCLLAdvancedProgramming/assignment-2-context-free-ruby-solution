startshape :doubled

shape :shapes do
  square hue: 0, saturation: 1, brightness: 1
  triangle x: 2, hue: 240, saturation: 1, brightness: 1
end

shape :doubled do
  shapes
  shapes y: 2
end
