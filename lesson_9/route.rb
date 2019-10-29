# frozen_string_literal: true

require_relative 'validation'
require_relative 'station'
require_relative 'railway_error'
require_relative 'general_methods'

class Route
  include GeneralMethods
  include Validation

  validate :start_station, :type, Station
  validate :end_station, :type, Station

  def initialize(start_station, end_station)
    @middle_stations = []
    @start_station = start_station
    @end_station = end_station

    validate!
  end

  def all_stations
    [@start_station] + @middle_stations + [@end_station]
  end

  def add_station(station)
    raise RailwayError.new, "Станция '#{station.title}' уже есть в маршруте" if @middle_stations.include?(station)

    @middle_stations << station
    true
  end

  def remove_station(station)
    unless (station != @start_station) && (station != @end_station)
      raise RailwayError.new, 'Нельзя изменять начальную и конечную станцию, создайте новый маршрут'
    end
    unless @middle_stations.include?(station)
      raise RailwayError.new, "Станция '#{station.title}' отсутствует в маршруте"
    end

    @middle_stations.delete(station)
    true
  end

  def show_stations
    all_stations.each { |station| puts station.title }
  end
end
