require_relative 'station'
require_relative 'railway_error'

class Route
  def initialize(start_station, end_station)
    @middle_stations = []
    @start_station = start_station
    @end_station = end_station

    validate!
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def all_stations
    [@start_station] + @middle_stations + [@end_station]
  end

  def add_station(station)
    if @middle_stations.include? station
      raise RailwayError.new, "Станция '#{station.title}' уже есть в маршруте"
    else
      @middle_stations << station
      true
    end
  end

  def remove_station(station)
    if (station != @start_station) && (station != @end_station)
      if @middle_stations.include? station
        @middle_stations.delete(station)
        true
      else
        raise RailwayError.new, "Станция '#{station.title}' отсутствует в маршруте"
      end
    else
      raise RailwayError.new, "Нельзя изменять начальную и конечную станцию, создайте новый маршрут"
    end
  end

  def show_stations
    all_stations.each { |station| puts station.title }
  end

  protected

  def validate!
    raise RailwayError.new, "Начальная станция должна быть объектом класса 'Станция'" unless @start_station.instance_of?(Station)
    raise RailwayError.new, "Конечная станция должна быть объектом класса 'Станция'" unless @end_station.instance_of?(Station)
    true
  end
end
