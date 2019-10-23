require_relative "train"
require_relative 'railway_error'

class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super(number)
    @type = "Грузовой"
    validate!
  end

  def add_cargo_carriage(carriage)
    if @current_speed == 0
      @carriages.push(carriage)
      puts "К поезду #{@number} прицеплен грузовой вагон, текущее количество вагонов #{@carriages.size}"
    else
      raise RailwayError.new, "Поезд не может прицеплять вагоны на ходу"
    end
  end

  def remove_cargo_carriage(carriage)
    if @current_speed == 0
      if @carriages.include?(carriage)
        @carriages.delete(carriage)
        puts "От поезда #{@number} отцеплен грузовой вагон, текущее количество вагонов #{@carriages.size}"
      else
        raise RailwayError.new, "У поезда #{number} отсутствуют вагоны"
      end
    else
      raise RailwayError.new, "Поезд не может отцеплять вагоны на ходу"
    end
  end
end
