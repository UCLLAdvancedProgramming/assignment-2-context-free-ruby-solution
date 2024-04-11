startshape :myshape

shape :myshape do
  mysquare

  rotsquare x: 40, y: 40
end

shape :rotsquare do
  mysquare rotate: 30
end

shape :mysquare do
  square size: [20, 20]
end
