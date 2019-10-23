class RailwayError < StandardError
  attr_reader :data

  def initialize(data = nil)
    @data = data
  end
end
