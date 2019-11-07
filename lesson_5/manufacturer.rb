module Manufacturer
  def get_manufacturer
    self.manufacturer_name
  end

  def set_manufacturer(name)
    self.manufacturer_name = name
  end

  # Если ставить protected то интерпретатор ругается что нельзя вызывать manufacturer_name так как он приватный
  # хотя модуль подключается к cargo_train.rb а не к train.rb
  attr_accessor :manufacturer_name
end
