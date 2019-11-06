print "Введите стороны треугольника через запятую: "
sides = gets.chomp
sides = sides.tr(" ", "")
sides = sides.split(",").map{|side| side.to_f}

if (sides[0] == sides[1]) && (sides[0] == sides[2])
  puts "Данный треугольник является равносторонним"
else
  longest_side = sides.max
  sides.delete_at(sides.index(longest_side))
  pifagor_formula_result = (longest_side ** 2) == ((sides[0] ** 2) + (sides[1] ** 2))

  if pifagor_formula_result
    puts "Треугольник является прямоугольным"
  else
    puts "Треугольник не является прямоугольным"
  end
end
