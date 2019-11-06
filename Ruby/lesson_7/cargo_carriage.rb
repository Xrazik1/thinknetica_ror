require_relative 'railway_error'

class CargoCarriage
  attr_reader :capacity

  def initialize(capacity)
    if capacity <= 0
      raise RailwayError.new, "Объем вагона должен быть больше нуля"
    else
      @capacity = @free_capacity = capacity
    end
  end

  def free_capacity
    @free_capacity
  end

  def used_capacity
    @capacity - @free_capacity
  end

  def use_capacity(capacity)
    if @free_capacity >= capacity
      @free_capacity -= capacity
    else
      raise RailwayError.new, "В вагоне отсутствует необходимый объем"
    end
  end
end
