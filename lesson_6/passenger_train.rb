require_relative "train"
require_relative 'railway_error'

class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super(number)
    @type = "Пассажирский"
  end

  def add_passenger_carriage(carriage)
    if @current_speed == 0
      @carriages.push(carriage)
    else
      raise RailwayError.new, "Поезд не может прицеплять вагоны на ходу"
    end
  end

  def remove_passenger_carriage(carriage)
    if @current_speed == 0
      if @carriages.include?(carriage)
        @carriages.delete(carriage)
      else
        raise RailwayError.new, "У поезда #{number} отсутствуют вагоны"
      end
    else
      raise RailwayError.new, "Поезд не может отцеплять вагоны на ходу"
    end
  end
end
