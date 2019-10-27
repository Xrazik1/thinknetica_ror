# frozen_string_literal: true

require_relative 'train'
require_relative 'railway_error'

class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super(number)
    @type = 'Грузовой'
    validate!
  end

  def add_cargo_carriage(carriage)
    if @current_speed == 0
      @carriages.push(carriage)
    else
      raise RailwayError.new, 'Поезд не может прицеплять вагоны на ходу'
    end
  end

  def remove_cargo_carriage(carriage)
    if @current_speed == 0
      if @carriages.include?(carriage)
        @carriages.delete(carriage)
      else
        raise RailwayError.new, "У поезда #{number} отсутствуют вагоны"
      end
    else
      raise RailwayError.new, 'Поезд не может отцеплять вагоны на ходу'
    end
  end
end
