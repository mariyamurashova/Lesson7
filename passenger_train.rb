class PassengerTrain < Train

PassengerTrain.set_instances
PassengerTrain.set_register_instances

  def initialize(name)
    super
    @train_type = :passenger
  end
end