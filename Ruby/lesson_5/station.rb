require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_accessor :title

  @@station_instances = []

  def initialize(title)
    self.register_instance
    @@station_instances << self

    @title = title
    @passenger_trains = []
    @cargo_trains = []
  end

  def self.all_stations
    @@station_instances
  end

  def all_trains
    @cargo_trains + @passenger_trains
  end

  def accept_train(train)
    if train.type == "Грузовой"
      @cargo_trains << train
    elsif train.type == "Пассажирский"
      @passenger_trains << train
    end
  end

  def send_train(train)
    if all_trains.include? train
      if train.type == "Грузовой"
        @cargo_trains.delete(train)
      elsif train.type == "Пассажирский"
        @passenger_trains.delete(train)
      end
      puts "Поезд #{train.number} успешно отправлен со станции: #{@title}"
    else
      puts "Поезд с номером #{train.number} отсутствует на станции: #{@title}"
    end
  end

  def show_trains
    all_trains.each { |train| puts " - #{train.number}(#{train.type})" }
  end

  def show_train_type_quantity
    puts "Количество поездов на станции '#{@title}': Грузовых - #{@cargo_trains.size}, Пассажирских - #{@passenger_trains.size}"
  end
end
