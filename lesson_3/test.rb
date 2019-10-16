require './route'
require './train'
require './station'

train1 = Train.new("100", "Грузовой", 3)
train2 = Train.new("101", "Грузовой", 2)
train3 = Train.new("102", "Пассажирский", 5)
station1 = Station.new("Первая станция")
station2 = Station.new("Вторая станция")
station3 = Station.new("Третья станция")
station4 = Station.new("Четвертая станция")
route1 = Route.new(station1, station2)
route2 = Route.new(station2, station3)

route1.add_station(station3)
route1.add_station(station4)
train1.add_route(route1)
train2.add_route(route1)
train3.add_route(route1)

puts "------------------"
puts "Поезд 100 прицепляет вагон на начальной станции, отвозит на конечную, отцепляет его и возвращается обратно"
puts "------------------"
train1.add_carriage
train1.increase_speed_by(40)
train1.move_on_route("forward" )
train1.move_on_route("forward" )
train1.move_on_route("forward" )
train1.stop
train1.remove_carriage

train1.increase_speed_by(40)
train1.move_on_route("back" )
train1.move_on_route("back" )
train1.move_on_route("back" )

puts "------------------"
puts "Поезд 101 едет на станцию 3, прицепляет 2 вагона, едет на конечную станцию, отцепляет их и едет на станцию 4"
puts "------------------"
train2.increase_speed_by(100)
train2.move_on_route("forward" )
train2.stop
train2.add_carriage
train2.add_carriage
train2.increase_speed_by(100)
train2.move_on_route("forward" )
train2.move_on_route("forward" )
train2.stop
train2.remove_carriage
train2.remove_carriage
train2.increase_speed_by(90)
train2.move_on_route("back" )

puts "------------------"
puts "
Пассажирский поезд 102 едет на конечную станцию 2 по первому маршруту, откуда начинает движение по второму маршруту до конечной станции 3.
Но во время движения в маршрут добавляется станция 4. Как только поезд доехал до конечной станции, станция 4 удаляется из маршрута"
puts "------------------"
train3.increase_speed_by(50)
train3.move_on_route("forward")
train3.move_on_route("forward")
train3.move_on_route("forward")
train3.stop
train3.increase_speed_by(100)
route2.add_station(station4)
train3.move_on_route("back")
train3.move_on_route("back")
route2.remove_station(station4)

station1.show_trains_types
station2.show_trains_types
station3.show_trains_types
station4.show_trains_types
route2.show_stations