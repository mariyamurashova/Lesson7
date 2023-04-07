module InstanceCounter

   def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

module ClassMethods
  attr_reader :instances

  def set_instances
    @instances = 0
  end
  
  def instances_add
   return  @instances +=1
  end
   
  def set_register_instances
    @instance_count = 0 
  end

  def add_instance
      @instance_count ||= 0
      @instance_count += 1
  end
end

module InstanceMethods

  protected

  def register_instance_set
    return self.class.add_instance
  end
end
end