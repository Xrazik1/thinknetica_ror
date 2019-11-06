# frozen_string_literal: true

require_relative 'train'
require_relative 'railway_error'
require_relative 'validation'

class CargoTrain < Train
  include Validation

  attr_reader :type

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number)
    @type = 'Грузовой'

    validate!
  end

  def add_cargo_carriage(carriage)
    raise RailwayError.new, 'Поезд не может прицеплять вагоны на ходу' unless current_speed.zero?

    @carriages.push(carriage)
  end

  def remove_cargo_carriage(carriage)
    raise RailwayError.new, 'Поезд не может отцеплять вагоны на ходу' unless @current_speed.zero?
    raise RailwayError.new, "У поезда #{number} отсутствуют вагоны" unless @carriages.include?(carriage)

    @carriages.delete(carriage)
  end
end
