STATION_NAME = /^[А-Я]{1}[а-я]{2,}\d{1,}*/

class Station

  include InstanceCounter
  include InstanceCounter
  include Validation
  attr_accessor :name
  Station.set_instances
  Station.set_register_instances
  @@stations = []

  def self.all_st 
    @@stations.each_with_index {|station, index| puts "#{index} - #{station.name}, #{station}"}
  end

  def initialize(name)
    @name = name
    @trains_on_station = [] 
    validation! 
    @@stations << self   
  end
   
  def come_in_trains(train)
    @trains_on_station << train
  end
  
  def show_train_list
    @trains_on_station.each.each_with_index  {|train, index|  puts "#{index} - Поезд #{train.number}:#{train.train_type} количество вагонов - #{train.carriage_number}"}
  end

  def total_trains_number
    return @trains_on_station.length
  end

  def leave_station(train)
    @trains_on_station.delete(train)
  end

  protected

  def validation!
  raise "Название станции не может быть короче 3 символов" if name.length < 3
  raise "Недопустимый формат имени" if name !~ STATION_NAME
  end
end
