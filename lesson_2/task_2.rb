range = (10..100)
array = []

range.each do |number|
  if (number % 5) == 0
    array.push(number)
  end
end

puts array
