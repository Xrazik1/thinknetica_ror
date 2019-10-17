class Train
  attr_reader :current_speed
  attr_reader :carriages_quantity
  attr_reader :number
  attr_reader :type

  def initialize(number, type, carriages_quantity)
    @number = number
    @type = type
    @carriages_quantity = carriages_quantity
    @current_speed = 0
    @current_station
    @route
  end

  def add_route(route)
    @route = route
    @current_station = @route.all_stations[0]
    @current_station.accept_train(self)
  end

  def increase_speed_by(speed)
    @current_speed += speed
  end

  def stop
    @current_speed = 0
  end


  def add_carriage
    if @current_speed == 0
      @carriages_quantity += 1
      puts "К поезду #{@number} прицеплен вагон, текущее количество вагонов #{@carriages_quantity}"
    else
      puts "Поезд не может прицеплять вагоны на ходу"
    end
  end

  def remove_carriage
    if @current_speed == 0
      if @carriages_quantity != 0
        @carriages_quantity -= 1
        puts "От поезда #{@number} отцеплен вагон, текущее количество вагонов #{@carriages_quantity}"
      else
        puts "У поезда #{number} уже отсутствуют вагоны"
      end

    else
      puts "Поезд не может отцеплять вагоны на ходу"
    end
  end

  # Это не плохо что у двух методов код почти полностью дублируется за исключением пары строк?
  def move_back
    if @current_speed != 0
      target_station_index = @route.all_stations.find_index(@current_station) - 1
      last_possible_station_index = -1

      if target_station_index != last_possible_station_index
        @current_station.send_train(self)
        @route.all_stations[target_station_index].accept_train(self)
        @current_station = @route.all_stations[target_station_index]

        puts "Поезд #{@number} прибыл на станцию: #{@current_station.title}"
      else
        puts "Поезд #{@number} уже на начальной станции"
      end
    else
      puts "Поезд не может менять станции так как стоит на месте"
    end
  end

  def move_forward
    if @current_speed != 0
      target_station_index = @route.all_stations.find_index(@current_station) + 1
      last_possible_station_index = @route.all_stations.length

      if target_station_index != last_possible_station_index
        @current_station.send_train(self)
        @route.all_stations[target_station_index].accept_train(self)
        @current_station = @route.all_stations[target_station_index]

        puts "Поезд #{@number} прибыл на станцию: #{@current_station.title}"
      else
        puts "Поезд #{@number} уже на конечной станции"
      end
    else
      puts "Поезд не может менять станции так как стоит на месте"
    end
  end


  def show_station(which)
    case which
    when "current"
      return @current_station
    when "previous"
      target_station_index = @route.all_stations.find_index(@current_station) - 1
      last_possible_station_index = -1

      if target_station_index != last_possible_station_index
        return @route.all_stations[target_station_index]
      else
        puts "Поезд на начальной станции"
      end
    when "next"
      target_station_index = @route.all_stations.find_index(@current_station) + 1
      last_possible_station_index = @route.all_stations.length
      if target_station_index != last_possible_station_index
        return @route.all_stations[target_station_index]
      else
        puts "Поезд на конечной станции"
      end
    else
      puts "Такого направления не существует (#{action})"
    end
  end
end
