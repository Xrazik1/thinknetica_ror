class Station
  attr_reader :title

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
      puts "Поезд #{train.number} успешно отправлен со станции: #{@title}"
    else
      puts "Поезд с номером #{train.number} отсутствует на станции: #{@title}"
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

    puts "Количество пассажирских поездов на станции '#{@title}': #{passenger_trains_quantity}, грузовых: #{cargo_trains_quantity}"
  end
end
