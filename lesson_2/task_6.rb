products = {}

def add_product(products, name, quantity, price)
  products[name] = {
      :product_price => price,
      :product_quantity => quantity,
      :product_total_price => quantity * price
  }

  return products
end

loop do
  print "Введите название товара: "
  product_name = gets.chomp.to_s

  if product_name == "стоп"
    total_price = 0

    puts "Ваши продукты: "
    products.each do |name, data|
      total_price += data[:product_total_price]
      puts "#{name}, Количество: #{data[:product_quantity]} шт, Цена: #{data[:product_price]} руб, Стоимость: #{data[:product_total_price]} руб"
      puts "---------------"
    end

    puts "Общая стоимость ваших продуктов: #{total_price} рублей"
    puts "---------------"
    break
  end

  print "Введите цену за единицу товара: "
  product_price = gets.chomp.to_f
  print "Введите количество товара: "
  product_quantity = gets.chomp.to_i

  if products.has_key? product_name
    product_quantity_total = product_quantity + products[product_name][:product_quantity]
    products = add_product(products, product_name, product_quantity_total, products[product_name][:product_price])
  else
    products = add_product(products, product_name, product_quantity, product_price)
  end
end
