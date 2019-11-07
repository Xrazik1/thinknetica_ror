# frozen_string_literal: true

require_relative 'railway_error'

class PassengerCarriage
  attr_reader :seats

  def initialize(seats)
    raise RailwayError.new, 'Количество мест в вагоне должно быть больше нуля' if seats <= 0

    @seats = @vacant_seats = seats
  end

  attr_reader :vacant_seats

  def used_seats
    @seats - @vacant_seats
  end

  def use_seat
    raise RailwayError.new, 'В вагоне отсутствуют свободные места' unless @vacant_seats != 0

    @vacant_seats -= 1
  end
end
