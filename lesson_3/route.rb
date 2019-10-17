class Route
  def initialize(start_station, end_station)
    @middle_stations = []
    @start_station = start_station
    @end_station = end_station
  end

  def all_stations
    [@start_station] + @middle_stations + [@end_station]
  end

  def add_station(station)
    if @middle_stations.include? station
      puts "Станция '#{station.title}' уже есть в маршруте"
    else
      @middle_stations << station
      puts "Станция '#{station.title}' добавлена в маршрут"
    end
  end

  def remove_station(station)
    if (station != @start_station) || (station != @end_station)
      if @middle_stations.include? station
        @middle_stations.delete(station)
        puts "Станция '#{station.title}' удалена из маршрута"
      else
        puts "Станция '#{station.title}' отсутствует в маршруте"
      end
    else
      puts "Нельзя изменять начальную и конечную станцию, создайте новый маршрут"
    end
  end

  def show_stations
    all_stations.each { |station| puts station.title }
  end
end
