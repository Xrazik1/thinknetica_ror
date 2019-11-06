require_relative 'manufacturer'

class PassengerCarriage
  include Manufacturer

  attr_reader :people_quantity

  def initialize
    @people_quantity = 0
  end

  def add_passengers(quantity)
    @people_quantity += quantity
  end

  def remove_passengers(quantity)
    @people_quantity -= quantity
  end
end
