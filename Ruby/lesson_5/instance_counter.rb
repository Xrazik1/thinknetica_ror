module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
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
      self.class.instances_count = (self.class.instances_count || 0) + 1
    end
  end
end

