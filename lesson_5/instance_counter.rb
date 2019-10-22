module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    # Почему-то без base.send всё работает
    base.include InstanceMethods
    base.instances_count = 0
  end

  module ClassMethods
    attr_accessor :instances_count

    def instances
      @instances_count
    end
  end

  module InstanceMethods
    protected
    def register_instance
      self.class.instances_count += 1
    end
  end
end

