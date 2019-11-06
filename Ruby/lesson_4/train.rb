class Train
  attr_reader :current_speed
  attr_accessor :number
  attr_reader :carriages
  attr_reader :route

  def initialize(number)
    @number = number
    @carriages = []
    @current_speed = 0
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

  def move_back
    if @route != nil
      if @current_speed != 0
        prev_station_result = prev_station

        if prev_station_result != nil
          @current_station.send_train(self)
          prev_station_result.accept_train(self)
          @current_station = prev_station_result

          puts "Поезд #{@number} прибыл на станцию: #{@current_station.title}"
        else
          puts "Поезд #{@number} уже на начальной станции"
        end
      else
        puts "Поезд не может менять станции так как стоит на месте"
      end
    else
      puts "Задайте маршрут чтобы управлять поездом"
    end

  end

  def move_forward
    if @route != nil
      if @current_speed != 0
        next_station_result = next_station

        if next_station_result != nil
          @current_station.send_train(self)
          next_station_result.accept_train(self)
          @current_station = next_station_result

          puts "Поезд #{@number} прибыл на станцию: #{@current_station.title}"
        else
          puts "Поезд #{@number} уже на конечной станции"
        end
      else
        puts "Поезд не может менять станции так как стоит на месте"
      end
    else
      puts "Задайте маршрут чтобы управлять поездом"
    end
  end


  def show_station(which)
    case which
    when "current"
      return @current_station
    when "previous"
      prev_station_result = prev_station

      if prev_station_result != nil
        return prev_station_result
      else
        puts "Поезд на начальной станции"
      end
    when "next"
      next_station_result = next_station

      if next_station_result != nil
        return next_station_result
      else
        puts "Поезд на конечной станции"
      end
    else
      puts "Такого направления не существует (#{action})"
    end
  end

  private

  # Внутренний метод для того чтобы не повторять проверки в show_station и move_back
  def prev_station
    target_station_index = @route.all_stations.find_index(@current_station) - 1
    last_possible_station_index = -1

    if target_station_index != last_possible_station_index
      @route.all_stations[target_station_index]
    else
      nil
    end
  end

  # Внутренний метод для того чтобы не повторять проверки в show_station и move_forward
  def next_station
    target_station_index = @route.all_stations.find_index(@current_station) + 1
    last_possible_station_index = @route.all_stations.length

    if target_station_index != last_possible_station_index
      @route.all_stations[target_station_index]
    else
      nil
    end
  end
end
