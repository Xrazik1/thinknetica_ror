alphabet = ('а'..'я')

vowels = "аоиеэыуюя"

vowel_alphabet = {}

alphabet.each.with_index(1) do |letter, position|
  if vowels.include? letter
    vowel_alphabet[letter] = position
  end
end

puts vowel_alphabet
