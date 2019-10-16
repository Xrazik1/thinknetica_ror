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
    @current_station = {}
    @route = {}
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

  # Лучше разделять действия на разные методы, или сделать один метод change_carriage
  # где через switch выбирать добавлять или удалять вагоны как в move_on_route?
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
      @carriages_quantity -= 1
      puts "От поезда #{@number} отцеплен вагон, текущее количество вагонов #{@carriages_quantity}"
    else
      puts "Поезд не может отцеплять вагоны на ходу"
    end
  end


  def move_on_route(action)
    if @current_speed == 0
      puts "Поезд не может менять станции так как стоит на месте"
    else
      case action
      when "back"
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
      when "forward"
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
        puts "Поезд не может двигаться в данном направлении (#{action})"
      end
    end

  end


  def show_station(which)
    case which
    when "current"
      puts @current_station.title
    when "previous"
      target_station_index = @route.all_stations.find_index(@current_station) - 1
      last_possible_station_index = -1

      if target_station_index != last_possible_station_index
        puts @route.all_stations[target_station_index].title
      else
        puts "Поезд на начальной станции"
      end
    when "next"
      target_station_index = @route.all_stations.find_index(@current_station) + 1
      last_possible_station_index = @route.all_stations.length
      if target_station_index != last_possible_station_index
        puts @route.all_stations[target_station_index].title
      else
        puts "Поезд на конечной станции"
      end
    else
      puts "Такого направления не существует (#{action})"
    end
  end
end
