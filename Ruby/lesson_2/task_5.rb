print "Введите число, месяц, год через точку: "
numbers = numbers_string = gets.chomp
numbers = numbers.tr(" ", "")
numbers = numbers.split(".").map{|number| number.to_i}
day, month, year = numbers[0], numbers[1], numbers[2]

days_in_february = (year % 400) == 0 ? 29 : 28
days_in_months = [31, days_in_february, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

sequence_number = 0
days_in_months.each.with_index(1) do |day_number, index|
  if index < month
    sequence_number += day_number
  end
end

sequence_number += day

puts "Порядковый номер даты #{numbers_string} - #{sequence_number}"

