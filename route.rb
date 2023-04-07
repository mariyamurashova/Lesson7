class Route
include InstanceCounter
include InstanceCounter
include Validation
attr_accessor :stations
 Route.set_instances
 Route.set_register_instances

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [@first_station, @last_station]
    validation!
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
    @stations.compact
  end

  def show_route
    @stations.each {|station| print "#{station.name} > "}
    puts " "
  end

  def validation!
  raise "Ошибка: заданы 2 одинаковые станции" if @first_station == @last_station
  raise "Станция с заданным номером не существует" if (@first_station == nil || @last_station == nil)
end
end
