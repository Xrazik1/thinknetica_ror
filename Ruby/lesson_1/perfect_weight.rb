print "Введите ваше имя: "
name = gets.chomp
print "Введите ваш рост: "
growth = gets.chomp.to_i

weight = growth - 110

if weight <= 0
  puts "Здравствуйте, #{name}, ваш вес уже оптимальный"
else
  puts "Здравствуйте, #{name}, ваш оптимальный вес: #{weight}"
end
