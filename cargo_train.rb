class CargoTrain < Train

  CargoTrain.set_instances
  CargoTrain.set_register_instances
  
  def initialize(number)
    super
    @train_type= :cargo 
  end
end