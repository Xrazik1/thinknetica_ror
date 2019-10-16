starts_from = 1
ends_at = 100
fi_numbers = [starts_from, starts_from]

while (fi_numbers[-1] + fi_numbers[-2]) < ends_at
  fi_number = fi_numbers[-1] + fi_numbers[-2]
  fi_numbers.push(fi_number)
end

puts fi_numbers
