startshape :squares

shape :squares do
  10.times do |i|
    hsquares y: 1.5 * i
  end
end

shape :hsquares do
  10.times do |i|
    red_or_black x: 1.5 * i
  end
end

shape :red_or_black

rule do
  square hue: 0, brightness: 1, saturation: 1
end

rule 3 do
  square
end
