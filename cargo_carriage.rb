class CargoCarriage < Train
  include ProduceCompany
  
  def initialize (full_carriage_value)
  @type= :cargo
  @full_carriage_value = full_carriage_value
  @taken = 0
  end
end
