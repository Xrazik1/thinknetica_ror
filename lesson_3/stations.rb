class Station
  def initialize(title)
    @title = title
    @trains = []
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    if @trains.include? train
      @trains.delete(train)
      puts "Поезд #{train.number} успешно отправлен"
    else
      puts "Поезд с номером #{train.number} отсутствует на станции"
    end
  end

  def show_trains
    @trains.each { |train| puts "#{train.number}(#{train.type})" }
  end

  def show_trains_types
    passenger_trains_quantity = 0
    cargo_trains_quantity = 0

    @trains.each do |train|
      if train.type.downcase == "пассажирский"
        passenger_trains_quantity += 1
      elsif train.type.downcase == "грузовой"
        cargo_trains_quantity += 1
      end
    end

    puts "Количество пассажирских поездов: #{passenger_trains_quantity}, грузовых: #{cargo_trains_quantity}"
  end
end

class Route
  def initialize
    @stations = []
  end
end

class Train
  attr_reader :current_speed
  attr_reader :carriages_quantity

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
    @current_station = route.stations[0]
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
    @current_speed == 0 ? @carriages_quantity += 1 : puts "Поезд не может прицеплять вагоны на ходу"
  end

  def remove_carriage
    @current_speed == 0 ? @carriages_quantity -= 1 : puts "Поезд не может отцеплять вагоны на ходу"
  end

  # Не слишком ли длинные условия?
  def move_on_route(action)
    case action
    when "back"
      target_station_index = @route.stations.find_index(@current_station) - 1
      last_possible_station_index = -1
      target_station_index != last_possible_station_index ? @current_station = @route.stations[target_station_index] : puts "Поезд уже на начальной станции"
    when "forward"
      target_station_index = @route.stations.find_index(@current_station) + 1
      last_possible_station_index = @route.station.length
      target_station_index != last_possible_station_index ? @current_station = @route.stations[target_station_index] : puts "Поезд уже на конечной станции"
    else
      puts "Поезд не может двигаться в данном направлении (#{action})"
    end
  end


  def show_station(which)
    case which
    when "current"
      puts @current_station.title
    when "previous"
      target_station_index = @route.stations.find_index(@current_station) - 1
      last_possible_station_index = -1
      target_station_index != last_possible_station_index ? puts @route.stations[target_station_index].title : puts "Поезд на начальной станции"
    when "next"
      target_station_index = @route.stations.find_index(@current_station) + 1
      last_possible_station_index = @route.station.length
      target_station_index != last_possible_station_index ? puts @route.stations[target_station_index].title : puts "Поезд на конечной станции"
    else
      puts "Такого направления не существует (#{action})"
    end
  end
end