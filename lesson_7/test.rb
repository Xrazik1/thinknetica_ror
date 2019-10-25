require_relative 'route'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'
require_relative 'station'

cargo1 = CargoCarriage.new(200)
cargo2 = CargoCarriage.new(100)
cargo3 = CargoCarriage.new(200)
passenger1 = PassengerCarriage.new(10)
passenger2 = PassengerCarriage.new(10)
passenger3 = PassengerCarriage.new(30)
train1 = CargoTrain.new("10A-90")
train2 = CargoTrain.new("AA110")
train3 = PassengerTrain.new("111-00")
station1 = Station.new("Первая станция")
station2 = Station.new("Вторая станция")
station3 = Station.new("Третья станция")
station4 = Station.new("Четвертая станция")
route1 = Route.new(station1, station2)
route2 = Route.new(station2, station3)

puts "Свободный объем вагона: #{cargo1.free_capacity}"
puts "Занятый объем вагона: #{cargo1.used_capacity}"
cargo1.use_capacity(10)
puts "Свободный объем вагона: #{cargo1.free_capacity}"
puts "Занятый объем вагона: #{cargo1.used_capacity}"

puts "Количество свободных мест: #{passenger1.vacant_seats}"
puts "Количество занятых мест: #{passenger1.used_seats}"
passenger1.use_seat
passenger1.use_seat
puts "Количество свободных мест: #{passenger1.vacant_seats}"
puts "Количество занятых мест: #{passenger1.used_seats}"

train1.add_cargo_carriage(cargo1)
train1.add_cargo_carriage(cargo2)

train1.iterate_carriages { |carriage| puts "Количество свободного пространства #{carriage.free_capacity}" }
station1.iterate_trains { |train| puts "Поезда на станции #{train.number}" }

route1.add_station(station3)
route1.add_station(station4)
train1.add_route(route1)
train2.add_route(route1)
train3.add_route(route1)

puts "------------------"
puts "Поезд 100 прицепляет вагон на начальной станции, отвозит на конечную, отцепляет его и возвращается обратно"
puts "------------------"
train1.increase_speed_by(40)
train1.move_forward
train1.move_forward
train1.move_forward
train1.stop
train1.remove_cargo_carriage(cargo1)

train1.increase_speed_by(40)
train1.move_back
train1.move_back
train1.move_back

puts "------------------"
puts "Поезд 101 едет на станцию 3, прицепляет 2 вагона, едет на конечную станцию, отцепляет их и едет на станцию 4"
puts "------------------"


train2.increase_speed_by(100)
train2.move_forward
train2.stop
train2.add_cargo_carriage(cargo2)
train2.add_cargo_carriage(cargo3)
train2.increase_speed_by(100)
train2.move_forward
train2.stop
train2.remove_cargo_carriage(cargo2)
train2.remove_cargo_carriage(cargo3)
train2.increase_speed_by(100)
train2.move_forward
train2.stop

train2.increase_speed_by(90)
train2.move_back

puts "------------------"
puts "
Пассажирский поезд 102 едет на конечную станцию 2 по первому маршруту, откуда начинает движение по второму маршруту до конечной станции 3.
Но во время движения в маршрут добавляется станция 4. Как только поезд доехал до конечной станции, станция 4 удаляется из маршрута"
puts "------------------"
train3.add_passenger_carriage(passenger1)
train3.add_passenger_carriage(passenger2)
train3.increase_speed_by(50)
train3.move_forward
train3.stop
train3.increase_speed_by(50)
train3.move_forward
train3.move_forward
train3.stop
train3.increase_speed_by(100)
route2.add_station(station4)
train3.move_back
train3.move_back
train3.stop
route2.remove_station(station4)


station1.show_train_type_quantity
station2.show_train_type_quantity
station3.show_train_type_quantity
station4.show_train_type_quantity


route2.show_stations
