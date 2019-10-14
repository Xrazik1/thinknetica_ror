print "Введите основание треугольника: "
base = gets.chomp.to_f
print "Введите высоту треугольника: "
height = gets.chomp.to_f

area = 0.5 * base * height

puts "Площадь треугольника равна #{area} см^2"
