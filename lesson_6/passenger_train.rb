require "json"
require_relative "train"

class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super(number)
    @type = "Пассажирский"
  end

  def add_passenger_carriage(carriage)
    if @current_speed == 0
      @carriages.push(carriage)
      puts "К поезду #{@number} прицеплен пассажирский вагон, текущее количество вагонов #{@carriages.size}"
    else
      puts "Поезд не может прицеплять вагоны на ходу"
    end
  end

  def remove_passenger_carriage(carriage)
    if @current_speed == 0
      if @carriages.include?(carriage)
        @carriages.delete(carriage)
        puts "От поезда #{@number} отцеплен пассажирский вагон, текущее количество вагонов #{@carriages.size}"
      else
        puts "У поезда #{number} отсутствуют вагоны"
      end
    else
      puts "Поезд не может отцеплять вагоны на ходу"
    end
  end

  def add_passengers(carriage)
    if @carriages.include?(carriage)
      if @current_speed == 0
        carriage_number = @carriages.find_index(carriage) + 1
        new_passengers = rand(1..30)
        carriage.add_passengers(new_passengers)
        puts "В вагон #{carriage_number} добавлено #{new_passengers} чел, текущее количество - #{carriage.people_quantity} чел"
      else
        puts "Остановите поезд чтобы набрать пассажиров"
      end
    else
      puts "Такой вагон отсутствует в поезде #{@number}"
    end
  end

  def remove_passengers(carriage)
    if @carriages.include?(carriage)
      if @current_speed == 0
        carriage_number = @carriages.find_index(carriage) + 1
        current_passengers_quantity = carriage.people_quantity
        old_passengers = rand(1..current_passengers_quantity)
        carriage.remove_passengers(old_passengers)
        puts "Из вагона #{carriage_number} удалено #{old_passengers} чел, текущее количество - #{carriage.people_quantity} чел"
      else
        puts "Остановите поезд чтобы набрать пассажиров"
      end
    else
      puts "Такой вагон отсутствует в поезде #{@number}"
    end
  end
end