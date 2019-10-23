require_relative 'railway_error'

class Station
  attr_reader :title

  def initialize(title)
    @title = title
    @passenger_trains = []
    @cargo_trains = []

    validate!
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def change_title(new_title)
    @title = new_title
    validate!
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
      true
    else
      raise RailwayError.new, "Поезд с номером #{train.number} отсутствует на станции: #{@title}"
    end
  end

  def show_trains
    all_trains.each { |train| puts " - #{train.number}(#{train.type})" }
  end

  def show_train_type_quantity
    puts "Количество поездов на станции '#{@title}': Грузовых - #{@cargo_trains.size}, Пассажирских - #{@passenger_trains.size}"
  end

  protected

  def validate!
    raise RailwayError.new, "Название станции не может быть пустой строкой!" if title == ""
    true
  end
end
