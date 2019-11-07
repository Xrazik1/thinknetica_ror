# frozen_string_literal: true

require_relative 'railway_error'
require_relative 'general_methods'

class Train
  include GeneralMethods

  attr_reader :current_speed
  attr_reader :number
  attr_reader :carriages
  attr_reader :route

  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i.freeze

  def initialize(number)
    @number = number
    @carriages = []
    @current_speed = 0

    validate!
  end

  def change_number(new_number)
    @number = new_number
    validate!
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
    raise RailwayError.new, 'Задайте маршрут чтобы управлять поездом' if @route.nil?

    prev_station_result = prev_station
    raise RailwayError.new, "Поезд #{@number} уже на начальной станции" if prev_station_result.nil?
    raise RailwayError.new, 'Поезд не может менять станции так как стоит на месте' if @current_speed.zero?

    @current_station.send_train(self)
    prev_station_result.accept_train(self)
    @current_station = prev_station_result
    true
  end

  def move_forward
    raise RailwayError.new, 'Задайте маршрут чтобы управлять поездом' if @route.nil?

    next_station_result = next_station
    raise RailwayError.new, "Поезд #{@number} уже на конечной станции" if next_station_result.nil?
    raise RailwayError.new, 'Поезд не может менять станции так как стоит на месте' if @current_speed.zero?

    @current_station.send_train(self)
    next_station_result.accept_train(self)
    @current_station = next_station_result
    true
  end

  # rubocop: disable Metrics/MethodLength
  def show_station(which)
    case which
    when 'current'
      @current_station
    when 'previous'
      prev_station_result = prev_station
      return prev_station_result unless prev_station_result.nil?

      puts 'Поезд на начальной станции'
    when 'next'
      next_station_result = next_station
      return next_station_result unless next_station_result.nil?

      puts 'Поезд на конечной станции'
    else
      puts "Такого направления не существует (#{action})"
    end
  end
  # rubocop: enable Metrics/MethodLength

  def each_carriage
    raise RailwayError.new, "У поезда '#{number}' отсутствуют вагоны" if @carriages.empty?

    @carriages.each.with_index(1) { |carriage, number| yield(carriage, number) }
  end

  protected

  def validate!
    raise RailwayError.new, 'Номер поезда не может быть пустой строкой!' if number == ''
    raise RailwayError.new, 'Номер поезда не соответствует формату' if number !~ NUMBER_FORMAT
  end

  private

  def prev_station
    target_station_index = @route.all_stations.find_index(@current_station) - 1
    last_possible_station_index = -1

    @route.all_stations[target_station_index] if target_station_index != last_possible_station_index
  end

  def next_station
    target_station_index = @route.all_stations.find_index(@current_station) + 1
    last_possible_station_index = @route.all_stations.length

    @route.all_stations[target_station_index] if target_station_index != last_possible_station_index
  end
end
