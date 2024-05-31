startshape :spikes

minsize 0.2

shape :spikes do
  4.times do |i|
    spike rotate: i * 90
  end
end

shape :spike

rule do
  lspike
end

rule do
  lspike size: [-1, 1]
end

shape :lspike

rule do
  square
  lspike y: 0.98, size: 0.99, rotate: 1
end

rule 0.01 do
  spike rotate: 90
  spike rotate: -90
  lspike y: 0.98, size: 0.99, rotate: 1
end
