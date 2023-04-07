require_relative 'validation'
require_relative 'produce_company'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'passenger_carriage'
require_relative 'cargo_train'
require_relative 'cargo_carriage'

class Menu 

  block = lambda {|x, y| puts "Свободно #{x-y}"} 
  @@block_train = Proc.new do|index,i| puts "#{index}-вагон:#{i.type}"
        puts "Всего #{i.full_carriage_value}"
        puts "Занято #{i.taken}"
        i.free_seats_volume(block)
  end

  def initialize
    @stations = []
    @routes = [] 
    @trains = []
  end

  def train_information
    puts "Выберите поезд"
    @stations[@num_stat].show_train_list
    @num_train=gets.chomp.to_i
    print_carriages  
  end

  def taken_seats_or_value
    choose_train
    choose_carriage 
    if train_type_passenger?
        take_seat 
        puts "Занято 1 место"
      else
        puts "Введите объем груза"
        volume = gets.chomp.to_i
        take_volume(volume)
        puts "В вагон добавлен груз "
     end
  end

   def trains_on_station
    choose_station
    puts "Сейчас на станции находятся следующие поезда:"
    @stations[@num_stat].show_train_list
    puts "Всего #{@stations[@num_stat].total_trains_number} поезда"
  end

  def create_station
    begin
    puts "Введите название станции.Название вводится кирилицей, первая буква - заглавная, неменее 3 букв"
    name = gets.chomp
    station = Station.new(name)
    rescue StandardError => e
    puts "Error #{e.inspect}"
    retry
    end
    @stations << station
    puts "Создан объект - #{station.name}"
  end
  
  def create_passenger_train 
    begin
    puts "Введите номер пассажирского поезда"
    puts "Номер(кирилица) -3 буквы или цифры в любом порядке+необязательный дефис+2 буквы или цифры"
    number = gets.chomp
    train = PassengerTrain.new(number) 
    rescue StandardError => e
    puts "Error #{e.inspect}"
    retry
    end
    train.produce_company
    @trains << train
    puts "Создан объект - #{train.number}"
  end

   def create_cargo_train
    begin
    puts "Введите номер грузового поезда"
    puts "Номер(кирилица)-3 буквы или цифры в любом порядке+необязательный дефис+2 буквы или цифры"
    number = gets.chomp
    train = CargoTrain.new(number)
    rescue StandardError => e
    puts "Error #{e.inspect}"
    retry
    end
    train.produce_company
    @trains << train
    puts "Создан объект - #{train.number}"
  end
 

  def create_route
    begin
    new_stations_list
    puts "Введите номер первой станции маршрута"
    first = gets.chomp.to_i
    puts "Введите номер последней станции маршрута"
    last = gets.chomp.to_i
    route = Route.new(@stations[first], @stations[last])
    rescue StandardError => e
    puts "Error #{e.inspect}"
    retry
    end
    @routes << route
    puts "Создан маршрут - #{route}"
    route.show_route
  end

  def edite_route_add_station 
    puts "Выберите номер маршрута для редактирования"
    choose_route
    choose_station
    puts "#{@stations[@num_stat].name} будет добавлена в маршрут"
    @routes[@num_route].add_station(@stations[@num_stat])
    @routes[@num_route].show_route
  end

  def edite_route_delete_station 
    puts "Вы берите номер маршрута для редактирования"
    choose_route
    choose_station
    puts "#{@stations[@num_stat].name} будет удалена из маршрута "
    @routes[@num_route].delete_station(@stations[@num_stat])
    @routes[@num_route].show_route
  end

  def set_route
    puts "Выберите поезд для назначения маршрута"
    choose_train
    puts "Выберите необходимый маршрут"
    choose_route
    @trains[@num_train].train_route (@routes[@num_route])
    puts "Поезду #{@trains[@num_train].number} назначен маршрут"
  end

  def move_train_forward
    puts "Выберите поезд для перемещения"
    choose_train
      if @trains[@num_train].stations_on_route != nil 
         @trains[@num_train].moving_forward
         @trains[@num_train].current_train_position
      else
        puts "Поезду не назначен маршрут"
      end
  end

  def move_train_back
    puts "Выберите поезд для перемещения"
    choose_train
      if @trains[@num_train].stations_on_route != nil 
        @trains[@num_train].moving_back
        @trains[@num_train].current_train_position
      else
        puts "Поезду не назначен маршрут"
      end
  end

  def new_stations_list
    Station.all_st
  end

  def add_carriages
    choose_train
      if train_type_passenger?
         create_passenger_carriage
         add_new_carriage
      else
        create_cargo_carriage
        add_new_carriage
      end
  end

  def remove_carriage
    choose_train
    @trains[@num_train].remove_carriage(@trains[@num_train])
    @trains[@num_train].carriage_number
  end

  def find_train_with_number
    puts ("Введите номер поезда")
    number = gets.chomp.to_s
      if Train.find_train(number) == nil 
        puts " NILL "
      else
    puts " Объект - #{Train.find_train(number)}"
      end  
  end

  def create_passenger_carriage
    puts "Введите количество мест в вагоне"
    full_carriage_value = gets.chomp.to_i
    @carr_pass = PassengerCarriage.new (full_carriage_value)
    @carr_pass.produce_company
    puts "Создан passenger вагон"
  end

def create_cargo_carriage
    puts "Введите общий объем вагона"
    full_carriage_value = gets.chomp.to_i
    @carr_cargo = CargoCarriage.new(full_carriage_value)
    @carr_cargo.produce_company
    puts "Создан cargo вагон"
  end

  protected

  def take_seat
    @trains[@num_train].train_carriage[@carr_num].taken_volume_seats
  end

  def take_volume(volume)
    @trains[@num_train].train_carriage[@carr_num].taken_volume_seats(volume)
  end

  def print_carriages
    @trains[@num_train].train_carriage_print(@@block_train)
  end

  def choose_carriage
    puts "Выберите вагон"
    print_carriages
    @carr_num = gets.chomp.to_i
  end
 
       
  def add_new_carriage
    if train_type_passenger?
    @trains[@num_train].add_carriage(@trains[@num_train],@carr_pass)
  else
    @trains[@num_train].add_carriage(@trains[@num_train],@carr_cargo)
  end
    @trains[@num_train].carriage_number
  end
       
  def  train_type_passenger?
     @trains[@num_train].train_type == :passenger
  end 

  def choose_train
    puts "Выберите поезд"
    all_trains_list
    @num_train = gets.chomp.to_i
    puts "Поезд #{@trains[@num_train].number} - #{@trains[@num_train].train_type}"
  end

  def all_trains_list
    @trains.each_with_index {|train, index| puts "#{index} - <<#{train.number}>>"}
  end

  def new_routes_list
    @routes.each_with_index do |route, index| 
    print "#{index} - "
    route.show_route
    end
  end

  def choose_route
    puts "Всего маршрутов:#{Route.instances}"
    new_routes_list  
    @num_route = gets.chomp.to_i
  end

  def choose_station
    puts "Выберите номер станции "
    new_stations_list 
    @num_stat = gets.chomp.to_i  
    end
end

puts "Создавать станцию - 1"
puts "Создать пассажирский поезд - 2"
puts "Создать грузовой поезд - 3"
puts "Создать маршрут - 4"
puts "Редактировать маршрут, добавить станцию- 5"
puts "Редактировать маршрут, удалить станцию- 6"
puts "Назначать маршрут поезду - 7"
puts " Добавить вагоны к поезду - 8"
puts " Отцеплять вагон от поезда - 9"
puts " Переместить поезд по маршруту вперед - 10"
puts " Переместить поезд по маршруту назад - 11"
puts " Просмотреть список станций - 12"
puts " Просмотреть список поездов на станции - 13"
puts " Найти поезд по номеру - 14"
puts "Занять места (:passenger) или объем (:cargo) - 16"
puts " Выход - 0"

menu = Menu.new

loop do 
    mark = gets.to_i
  break if mark == 0
  
case mark
when 1 
    menu.create_station
    puts "Выберите следующее действие"
when 2
    menu.create_passenger_train 
    puts "Выберите следующее действие"
when 3
    menu.create_cargo_train
    puts "Выберите следующее действие"
when 4
  menu.create_route
  puts "Выберите следующее действие"
when 5
  menu.edite_route_add_station
  puts "Выберите следующее действие"
when 6
  menu.edite_route_delete_station
  puts "Выберите следующее действие"
when 7
  menu.set_route
  puts "Выберите следующее действие"
when 10
  menu.move_train_forward
  puts "Выберите следующее действие"
when 11
  menu.move_train_back
  puts "Выберите следующее действие"
when 12
  puts "Список станций"
  menu.new_stations_list
  puts "Выберите следующее действие"
when 13
  puts 
  menu.trains_on_station
  puts "Для просмотра информации о поезде на станции нажмите 15 или Выберите другое действие"
when 8
  puts 
  menu.add_carriages
  puts "Выберите следующее действие"
when 9
  puts 
  menu.remove_carriage
  puts "Выберите следующее действие"
when 14
  puts 
  menu.find_train_with_number
  puts "Выберите следующее действие"
when 15
  puts 
  menu.train_information
  puts "Выберите следующее действие"
when 16
  puts 
  menu.taken_seats_or_value
  puts "Выберите следующее действие"
end

end  

