module Manufacturer
  def get_manufacturer
    self.manufacturer_name
  end

  def set_manufacturer(name)
    self.manufacturer_name = name
  end

  private
  attr_accessor :manufacturer_name
end
