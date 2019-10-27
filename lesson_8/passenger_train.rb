# frozen_string_literal: true

require_relative 'train'
require_relative 'railway_error'

class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super(number)
    @type = 'Пассажирский'
  end

  def add_passenger_carriage(carriage)
    raise RailwayError.new, 'Поезд не может прицеплять вагоны на ходу' unless @current_speed.zero?

    @carriages.push(carriage)
  end

  def remove_passenger_carriage(carriage)
    raise RailwayError.new, 'Поезд не может отцеплять вагоны на ходу' unless @current_speed.zero?
    raise RailwayError.new, "У поезда #{number} отсутствуют вагоны" unless @carriages.include?(carriage)

    @carriages.delete(carriage)
  end
end
