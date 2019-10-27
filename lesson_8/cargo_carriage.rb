# frozen_string_literal: true

require_relative 'railway_error'

class CargoCarriage
  attr_reader :capacity

  def initialize(capacity)
    raise RailwayError.new, 'Объем вагона должен быть больше нуля' if capacity <= 0

    @capacity = @free_capacity = capacity
  end

  attr_reader :free_capacity

  def used_capacity
    @capacity - @free_capacity
  end

  def use_capacity(capacity)
    raise RailwayError.new, 'В вагоне отсутствует необходимый объем' unless @free_capacity >= capacity

    @free_capacity -= capacity
  end
end
