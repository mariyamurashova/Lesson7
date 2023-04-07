class PassengerCarriage < Train

  include ProduceCompany

  def initialize(full_carriage_value)
    @type= :passenger
    @taken = 0
    @full_carriage_value = full_carriage_value
  end
end