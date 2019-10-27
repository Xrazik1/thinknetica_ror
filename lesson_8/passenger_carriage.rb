# frozen_string_literal: true

require_relative 'railway_error'

class PassengerCarriage
  attr_reader :seats

  def initialize(seats)
    if seats <= 0
      raise RailwayError.new, 'Количество мест в вагоне должно быть больше нуля'
    else
      @seats = @vacant_seats = seats
    end
  end

  attr_reader :vacant_seats

  def used_seats
    @seats - @vacant_seats
  end

  def use_seat
    if @vacant_seats != 0
      @vacant_seats -= 1
    else
      raise RailwayError.new, 'В вагоне отсутствуют свободные места'
    end
  end
end
