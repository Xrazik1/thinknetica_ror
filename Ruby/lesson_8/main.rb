# frozen_string_literal: true

require_relative 'route'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'
require_relative 'station'
require_relative 'railway_error'

@config = {
  stations: [],
  trains: [],
  routes: []
}

# Menu structures

# rubocop: disable Metrics/MethodLength
# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/CyclomaticComplexity
def main_menu
  puts '1. Управление станциями'
  puts '2. Управление поездами'
  puts '3. Управление маршрутами'
  puts '4. Выход'
  print 'Выберите вариант: '
  item = gets.chomp.tr(' ', '').to_i
  raise RailwayError.new, 'Данного пункта меню не существует, повторите ввод' unless (1..4).include?(item)

  exit(true) if item == 4
  main_menu_controller(item)
rescue RailwayError => e
  puts e.message
  retry
end

def station_menu
  puts 'Добавьте или измените существующие станции'
  puts '1. Добавить новую станцию'

  @config[:stations]&.each&.with_index(2) { |station, number| puts "#{number}. #{station.title}" }
  back_menu_number = (@config[:stations].size + 2)
  puts "#{back_menu_number}. Назад"
  print 'Выберите пункт меню: '
  item = gets.chomp.tr(' ', '').to_i
  main_menu if item == back_menu_number
  station_menu_controller(item)
end

def trains_menu
  puts 'Добавьте или измените существующие поезда'
  puts '1. Добавить новый поезд'

  @config[:trains]&.each&.with_index(2) { |train, number| puts "#{number}. #{train.type} ##{train.number}" }
  back_menu_number = (@config[:trains].size + 2)
  puts "#{back_menu_number}. Назад"
  print 'Выберите пункт меню: '
  item = gets.chomp.tr(' ', '').to_i
  if item == back_menu_number
    main_menu
  else
    trains_menu_controller(item)
  end
end

def carriages_menu(chosen_train_number)
  puts 'Добавьте или измените существующие вагоны'
  puts '1. Добавить новый вагон'
  show_train_carriages(chosen_train_number) if @config[:trains][chosen_train_number].carriages
  back_menu_number = (@config[:trains][chosen_train_number].carriages.size + 2)
  puts "#{back_menu_number}. Назад"
  print 'Выберите пункт меню: '
  item = gets.chomp.tr(' ', '').to_i
  if item == back_menu_number
    train_menu(chosen_train_number)
  else
    carriages_menu_controller(item, chosen_train_number)
  end
end

def carriage_menu(carriage_number, chosen_train_number)
  train = @config[:trains][chosen_train_number]
  carriage = train.carriages[carriage_number]

  if carriage.instance_of?(CargoCarriage)
    puts "Информация о грузовом вагоне - Места занято: #{carriage.used_capacity} из #{carriage.capacity}"
    puts '1. Занять необходимое количество места'
  elsif carriage.instance_of?(PassengerCarriage)
    puts "Информация о пассажирском вагоне - Мест занято: #{carriage.used_seats} из #{carriage.seats}"
    puts '1. Использовать одно место'
  end
  puts '2. Удалить вагон'
  puts '3. К выбору вагона'
  print 'Выберите вариант: '
  item = gets.chomp.to_i
  if item == 3
    carriages_menu(chosen_train_number)
  else
    carriage_menu_controller(item, carriage_number, chosen_train_number)
  end
end

def train_menu(chosen_train_number)
  target_train = @config[:trains][chosen_train_number]
  train_carriages_count = target_train.carriages.size
  train_number = target_train.number
  train_type = target_train.type
  train_speed = target_train.current_speed
  train_route =
    if target_train.route
      "#{target_train.route.all_stations[0].title} - #{target_train.route.all_stations[-1].title}"
    else
      'отсутствует'
    end

  puts "Управление поездом '#{train_type} #{train_number}'"
  print 'Информация о поезде:'
  puts  "скорость #{train_speed}, маршрут '#{train_route}', количество вагонов #{train_carriages_count}'"
  puts '1. Изменить номер поезда'
  puts '2. Задать скорость поезду'
  puts '3. Добавить или заменить маршрут поезда'
  puts '4. Управление вагонами поезда'
  puts '5. Отправить поезд на следующую станцию'
  puts '6. Отправить поезд на предыдыдущую станцию'
  puts '7. Удалить поезд'
  puts '8. Назад'
  print 'Выберите вариант: '
  item = gets.chomp.to_i
  if item == 8
    trains_menu
  else
    train_menu_controller(item, chosen_train_number)
  end
end

def routes_menu
  raise RailwayError.new, 'Создайте хотя бы две станции чтобы создавать маршруты' if @config[:stations].empty?

  puts 'Добавьте или измените существующие маршруты'
  puts '1. Добавить новый маршрут'
  @config[:routes]&.each&.with_index(2) do |route, number|
    puts "#{number}. #{route.all_stations[0].title} - #{route.all_stations[-1].title}"
  end
  back_menu_number = (@config[:routes].size + 2)
  puts "#{back_menu_number}. Назад"
  print 'Выберите пункт меню: '
  item = gets.chomp.tr(' ', '').to_i
  if item == back_menu_number
    main_menu
  else
    routes_menu_controller(item)
  end
rescue RailwayError => e
  puts e.message
  main_menu
end

def route_menu(chosen_route_number)
  stations_in_route = @config[:routes][chosen_route_number].all_stations
  print 'Управление маршрутом '
  puts "#{stations_in_route[0].title} - #{stations_in_route[-1].title}"
  puts '1. Добавить промежуточную станцию в маршрут'
  puts '2. Удалить промежуточную станцию из маршрута'
  puts '3. Удалить маршрут'
  puts '4. К выбору маршрутов'
  print 'Выберите вариант: '
  item = gets.chomp.to_i
  routes_menu if item == 4
  route_menu_controller(item, chosen_route_number)
end

# Menu controllers
def main_menu_controller(item)
  case item
  when 1
    station_menu
  when 2
    trains_menu
  when 3
    routes_menu
  else
    main_menu
  end
end

def station_menu_controller(item)
  last_station_index = @config[:stations].empty? ? 2 : @config[:stations].size + 1
  case item
  when 1
    create_station
    station_menu
  when 2..last_station_index
    puts '1. Изменить название станции'
    puts '2. Показать список поездов на станции'
    print 'Выберите пункт меню: '
    station_item = gets.chomp.to_i

    unless (station_item == 1) || (station_item == 2)
      raise RailwayError.new, 'Произошла ошибка ввода пункта меню, вы были возвращены на предыдущий экран'
    end

    change_station_title(item - 2) if station_item == 1
    puts "Список поездов на станции '#{@config[:stations][item - 2].title}'"
    @config[:stations][item - 2].each_train { |train, number|  puts "#{number}. #{train.number}" }
    station_menu
  else
    raise RailwayError.new, 'Произошла ошибка ввода пункта меню, вы были возвращены на предыдущий экран'
  end
rescue RailwayError => e
  puts e.message
  station_menu
end

def trains_menu_controller(item)
  last_train_index = @config[:trains].empty? ? 2 : @config[:trains].size + 1
  case item
  when 1
    create_train
  when 2..last_train_index
    train_menu(item - 2)
  else
    raise RailwayError.new, 'Произошла ошибка ввода пункта меню, вы были возвращены на предыдущий экран'
  end
rescue RailwayError => e
  puts e.message
  trains_menu
end

def train_menu_controller(item, chosen_train_number)
  case item
  when 1
    change_train_number(chosen_train_number)
  when 2
    change_train_speed(chosen_train_number)
    train_menu(chosen_train_number)
  when 3
    raise RailwayError.new, 'У вас отсутствуют доступные маршруты, добавьте их' if @config[:routes].empty?

    change_train_routes(chosen_train_number)
    train_menu(chosen_train_number)
  when 4
    carriages_menu(chosen_train_number)
  when 5
    train_move_forward(chosen_train_number)
  when 6
    train_move_back(chosen_train_number)
  when 7
    remove_train(chosen_train_number)
    trains_menu
  else
    raise RailwayError.new, 'Произошла ошибка ввода пункта меню, вы были возвращены на предыдущий экран'
  end
rescue RailwayError => e
  puts e.message
  trains_menu
end

def route_menu_controller(item, chosen_route_number)
  puts 'Список станций в текущем маршруте(от начальной до конечной): '
  @config[:routes][chosen_route_number].all_stations.each { |station| puts "- #{station.title}" }
  case item
  when 1
    add_station_to_route(chosen_route_number)
  when 2
    remove_station_from_route(chosen_route_number)
  when 3
    remove_route(chosen_route_number)
    routes_menu
  else
    raise RailwayError.new, 'Произошла ошибка ввода пункта меню, вы были возвращены на предыдущий экран'
  end
rescue RailwayError => e
  puts e.message
  routes_menu
end

def routes_menu_controller(item)
  last_route_index = @config[:routes].empty? ? 2 : @config[:routes].size + 1
  case item
  when 1
    create_route(item)
  when 2..last_route_index
    route_menu(item - 2)
  else
    raise RailwayError.new, 'Произошла ошибка ввода пункта меню, вы были возвращены на предыдущий экран'
  end
rescue RailwayError => e
  puts e.message
  routes_menu
end

def carriages_menu_controller(item, chosen_train_number)
  last_carriage_index = if @config[:trains][chosen_train_number].carriages.empty?
                          2
                        else
                          @config[:trains][chosen_train_number].carriages.size + 1
                        end

  case item
  when 1
    add_carriage_to_train(chosen_train_number)
  when 2..last_carriage_index
    carriage_menu(item - 2, chosen_train_number)
  else
    raise RailwayError.new, 'Произошла ошибка ввода пункта меню, вы были возвращены на предыдущий экран'
  end
rescue RailwayError => e
  puts e.message
  carriages_menu(chosen_train_number)
end

def carriage_menu_controller(item, carriage_number, chosen_train_number)
  case item
  when 1
    change_carriage_space(carriage_number, chosen_train_number)
  when 2
    remove_carriage_from_train(carriage_number, chosen_train_number)
  else
    raise RailwayError.new, 'Произошла ошибка ввода пункта меню, вы были возвращены на предыдущий экран'
  end
rescue RailwayError => e
  puts e.message
  carriages_menu(chosen_train_number)
end

# Helpers

# Station

def create_station
  print 'Введите имя новой станции: '
  name = gets.chomp.to_s
  new_station = Station.new(name)
  @config[:stations] << new_station
  puts "Добавлена станция '#{name}'"
rescue RailwayError => e
  puts e.message
  retry
end

def change_station_title(station_number)
  puts 'Для удаления введите пустую строку'
  print 'Введите новое имя станции: '
  new_name = gets.chomp.to_s
  if new_name != ''
    config_station = @config[:stations][station_number]
    config_station.change_title(new_name)
    puts "Задано новое имя станции '#{new_name}'"
  else
    name = @config[:stations][station_number].title
    @config[:stations].delete_at(station_number)
    puts "Станция '#{name}' успешно удалена"
  end
rescue RailwayError => e
  puts e.message
  retry
end

# Train

def create_train
  print 'Для создания грузового поезда введите 1, пассажирского - 2: '
  type_item = gets.chomp.to_s

  if type_item == '1'
    print 'Введите номер поезда: '
    number = gets.chomp.to_s
    new_train = CargoTrain.new(number)
    @config[:trains] << new_train
    puts "Добавлен грузовой поезд '#{number}'"
  elsif type_item == '2'
    print 'Введите номер поезда: '
    number = gets.chomp.to_s
    new_train = PassengerTrain.new(number)
    @config[:trains] << new_train
    puts "Добавлен пассажирский поезд '#{number}'"
  else
    raise RailwayError.new, 'Произошла ошибка ввода, пожалуйста повторите'
  end

  trains_menu
rescue RailwayError => e
  puts e.message
  retry
end

def change_train_number(chosen_train_number)
  print 'Введите новый номер поезда: '
  new_number = gets.chomp.to_s
  config_train = @config[:trains][chosen_train_number]
  config_train.change_number(new_number)

  puts "Задан новый номер поезда '#{new_number}'"
  train_menu(chosen_train_number)
rescue RailwayError => e
  puts e.message
  retry
end

def remove_train(chosen_train_number)
  number = @config[:trains][chosen_train_number].number
  type = @config[:trains][chosen_train_number].type
  @config[:trains].delete_at(chosen_train_number)

  puts "#{type} поезд '#{number}' успешно удален"
end

def change_train_speed(chosen_train_number)
  puts "Текущая скорость поезда - #{@config[:trains][chosen_train_number].current_speed} км/ч"
  print 'На сколько увеличить скорость?(для полной остановки введите 0): '
  new_speed = gets.chomp.to_i
  config_train = @config[:trains][chosen_train_number]
  if new_speed.zero?
    config_train.stop
  else
    config_train.increase_speed_by(new_speed)
  end
  puts "Задана новая скорость поезда - #{@config[:trains][chosen_train_number].current_speed} км/ч"
end

def change_train_routes(chosen_train_number)
  puts '1. Добавить маршрут поезду(существующий маршрут будет заменён на новый)'
  train_route = get_train_route(@config[:trains][chosen_train_number])
  if !train_route.nil?
    puts 'Список станций в текущем маршруте(от начальной до конечной): '
    train_route.all_stations.each { |station| puts "- #{station.title}" }
  else
    puts 'У поезда отсутствует маршрут'
  end

  print 'Выберите пункт: '
  item = gets.chomp.to_i

  raise RailwayError.new, 'Такого пункта не существует, повторите ввод' unless item == 1

  puts 'Введите номер маршрута чтобы добавить его: '
  @config[:routes].each.with_index(1) do |route, number|
    puts "#{number}. Маршрут '#{route.all_stations[0].title} - #{route.all_stations[-1].title}'"
  end
  print 'Выберите маршрут: '
  route_item = gets.chomp.to_i

  unless (1..@config[:routes].size).include?(route_item)
    raise RailwayError.new, 'Такого пункта не существует, повторите ввод'
  end

  train = @config[:trains][chosen_train_number]
  config_route = @config[:routes][route_item - 1]
  train.add_route(config_route)
  print "К поезду '#{train.type} #{train.number}' привязан маршрут"
  puts "'#{config_route.all_stations[0].title} - #{config_route.all_stations[-1].title}'"
  trains_menu
rescue RailwayError => e
  puts e.message
  retry
end

def show_train_carriages(chosen_train_number)
  train = @config[:trains][chosen_train_number]
  first_carriage = @config[:trains][chosen_train_number].carriages[0]

  if first_carriage.instance_of?(CargoCarriage)
    train.each_carriage do |carriage, number|
      print "#{number + 1}. Вагон #{number}."
      puts "Количество свободных мест - #{carriage.free_capacity}, занятых - #{carriage.used_capacity}"
    end
  elsif first_carriage.instance_of?(PassengerCarriage)
    train.each_carriage do |carriage, number|
      print "#{number + 1}. Вагон #{number}."
      puts "Количество свободных мест - #{carriage.vacant_seats}, занятых - #{carriage.used_seats}"
    end
  end
rescue RailwayError => e
  puts e.message
end

def add_carriage_to_train(chosen_train_number)
  if @config[:trains][chosen_train_number].type == 'Пассажирский'
    print 'Введите количество мест в пассажирском вагоне: '
    seats = gets.chomp.to_i
    new_carriage = PassengerCarriage.new(seats)
    @config[:trains][chosen_train_number].add_passenger_carriage(new_carriage)
  else
    print 'Введите объем грузового вагона: '
    capacity = gets.chomp.to_i
    new_carriage = CargoCarriage.new(capacity)
    @config[:trains][chosen_train_number].add_cargo_carriage(new_carriage)
  end

  puts "К поезду #{@config[:trains][chosen_train_number].number} добавлен вагон"
  carriages_menu(chosen_train_number)
rescue RailwayError => e
  puts e.message
  carriages_menu(chosen_train_number)
end

def remove_carriage_from_train(carriage_number, chosen_train_number)
  target_carriage = @config[:trains][chosen_train_number].carriages[carriage_number]

  if @config[:trains][chosen_train_number].type == 'Пассажирский'
    @config[:trains][chosen_train_number].remove_passenger_carriage(target_carriage)
  else
    @config[:trains][chosen_train_number].remove_cargo_carriage(target_carriage)
  end

  puts "От поезда #{@config[:trains][chosen_train_number].number} удалён вагон"
  carriages_menu(chosen_train_number)
rescue RailwayError => e
  puts e.message
  carriages_menu(chosen_train_number)
end

def train_move_forward(chosen_train_number)
  train = @config[:trains][chosen_train_number]
  train.move_forward

  puts "Поезд #{train.number} прибыл на станцию: #{train.show_station('current').title}"
  train_menu(chosen_train_number)
rescue RailwayError => e
  puts e.message
  train_menu(chosen_train_number)
end

def train_move_back(chosen_train_number)
  train = @config[:trains][chosen_train_number]
  train.move_back

  puts "Поезд #{train.number} прибыл на станцию: #{train.show_station('current').title}"
  train_menu(chosen_train_number)
rescue RailwayError => e
  puts e.message
  train_menu(chosen_train_number)
end

def get_train_route(train)
  train_index = @config[:trains].index(train)
  config_train = @config[:trains][train_index]
  !config_train.route.nil? ? config_train.route : nil
end

def change_carriage_space(carriage_number, chosen_train_number)
  train = @config[:trains][chosen_train_number]
  carriage = train.carriages[carriage_number]

  if carriage.instance_of?(CargoCarriage)
    print 'Введите количество места, которое хотите занять: '
    capacity = gets.chomp.to_i
    carriage.use_capacity(capacity)
    puts "В вагоне занято #{capacity} места"
  elsif carriage.instance_of?(PassengerCarriage)
    carriage.use_seat
    puts 'В вагоне занято одно пассажирское место'
  end

  carriage_menu(carriage_number, chosen_train_number)
rescue RailwayError => e
  puts e.message
  carriage_menu(carriage_number, chosen_train_number)
end

# Route

def create_route(_item)
  @config[:stations].each.with_index(1) { |station, number| puts "#{number}. #{station.title}" }
  print 'Выберите начальную станцию маршрута: '
  start_station_item = gets.chomp.to_i

  @config[:stations].each.with_index(1) { |station, number| puts "#{number}. #{station.title}" }
  print 'Выберите конечную станцию маршрута: '
  end_station_item = gets.chomp.to_i

  raise RailwayError.new, 'Начальная и конечная станция не могут совпадать' if start_station_item == end_station_item

  if @config[:stations][start_station_item - 1].nil? && @config[:stations][end_station_item - 1].nil?
    raise RailwayError.new, 'Произошла ошибка ввода пунктов меню, повторите ввод'
  end

  new_route = Route.new(@config[:stations][start_station_item - 1], @config[:stations][end_station_item - 1])
  @config[:routes] << new_route

  print 'Добавлен маршрут '
  puts "'#{@config[:stations][start_station_item - 1].title} - #{@config[:stations][end_station_item - 1].title}'"

  routes_menu
rescue RailwayError => e
  puts e.message
  retry
end

def add_station_to_route(chosen_route_number)
  all_route_stations = @config[:routes][chosen_route_number].all_stations
  puts 'Список станций в текущем маршруте: '
  all_route_stations.each { |station| puts "- #{station.title}" }

  puts 'Список всех существующих станций: '
  @config[:stations].each.with_index(1) { |station, number| puts "#{number}. #{station.title}" }

  print 'Введите номер станции, которую хотите добавить: '
  station_item = gets.chomp.to_i

  unless (1..@config[:stations].size).include?(station_item)
    raise RailwayError.new, 'Вы ввели неверный номер станции, повторите ввод'
  end

  target_station = @config[:stations][station_item - 1]

  if (all_route_stations.size == 2) && all_route_stations.include?(target_station)
    raise RailwayError.new, 'Нельзя добавлять начальную и конечную стации как промежуточную, повторите ввод'
  end

  @config[:routes][chosen_route_number].add_station(target_station)
  puts "Станция '#{target_station.title}' добавлена в маршрут"
  routes_menu
rescue RailwayError => e
  puts e.message
  retry
end

def remove_station_from_route(chosen_route_number)
  all_route_stations = @config[:routes][chosen_route_number].all_stations
  puts 'Список станций в текущем маршруте: '
  all_route_stations.each.with_index(1) { |station, number| puts "#{number}. #{station.title}" }

  print 'Введите номер станции, которую хотите удалить: '
  station_item = gets.chomp.to_i

  raise RailwayError.new, 'Вы ввели неверный номер станции' unless (1..@config[:stations].size).include?(station_item)

  target_station = @config[:stations][station_item - 1]
  @config[:routes][chosen_route_number].remove_station(target_station)
  puts "Станция '#{target_station.title}' удалена из маршрута"
  routes_menu
rescue RailwayError => e
  puts e.message
  routes_menu
end

# rubocop: enable Metrics/MethodLength
# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/CyclomaticComplexity

def remove_route(chosen_route_number)
  route = @config[:routes][chosen_route_number]
  route_name = "#{route.all_stations[0].title} - #{route.all_stations[-1].title}"
  @config[:routes].delete_at(chosen_route_number)
  puts "Маршрут '#{route_name}' успешно удалён"
end

main_menu
