starts_from = 1
ends_at = 100
f_numbers = [starts_from, starts_from]

loop do
  f_number = f_numbers[-1] + f_numbers[-2]
  f_number > ends_at ? break : f_numbers.push(f_number)
end

puts f_numbers
