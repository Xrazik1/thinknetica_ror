# frozen_string_literal: true

require_relative 'station'
require_relative 'railway_error'
require_relative 'general_methods'

class Route
  include GeneralMethods

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
    if @middle_stations.include?(station)
      raise RailwayError.new, "Станция '#{station.title}' уже есть в маршруте"
    end

    @middle_stations << station
    true
  end

  def remove_station(station)
    unless (station != @start_station) && (station != @end_station)
      raise RailwayError.new, 'Нельзя изменять начальную и конечную станцию, создайте новый маршрут'
    end
    raise RailwayError.new, "Станция '#{station.title}' отсутствует в маршруте" unless @middle_stations.include?(station)

    @middle_stations.delete(station)
    true
  end

  def show_stations
    all_stations.each { |station| puts station.title }
  end

  protected

  def validate!
    unless @start_station.instance_of?(Station)
      raise RailwayError.new, "Начальная станция должна быть объектом класса 'Станция'"
    end
    unless @end_station.instance_of?(Station)
      raise RailwayError.new, "Конечная станция должна быть объектом класса 'Станция'"
    end
  end
end
