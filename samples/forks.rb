startshape :forks, brightness: 0.8, saturation: 0.5

background brightness: -0.8

nb_forks = 12

shape :forks do
  degrees_per_fork = 360.0 / nb_forks
  nb_forks.times do |i|
    fork rotate: degrees_per_fork * i, hue: degrees_per_fork * i
  end
end

shape :fork do
  square y: 10, size: [1, 15]
  teeth y: 17.5
end

shape :teeth do
  square size: [2.7, 1]
  [-1, 0, 1].each do |i|
    tooth x: i, y: 2.5
  end
end

shape :tooth do
  triangle size: [0.5, 8]
end
