print "Введите a,b,c квадратного уравнения через запятую: "
args = gets.chomp
args = args.tr(" ", "")
args = args.split(",").map{|arg| arg.to_i}
a, b, c = args[0], args[1], args[2]

d = ((b ** 2) - (4 * a * c))

if d < 0
  puts "Дискриминант меньше нуля, корни вычислить нельзя"
elsif d == 0
  x = -b / (2 * a)

  puts "x = #{x}"
else
  d_sqrt = Math.sqrt(d)
  x1 = (-b + d_sqrt) / (2 * a)
  x2 = (-b - d_sqrt) / (2 * a)

  puts "x1 = #{x1}, x2 = #{x2}"
end
