# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym

        define_method("#{name}_history".to_sym) { history_get(name.to_sym) }
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=".to_sym) { |value| history_save(name.to_sym, value) }
      end
    end

    def strong_attr_accessor(source_class, *names)
      names.each do |name|
        var_name = "@#{name}".to_sym

        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=".to_sym) do |value|
          raise "Passed a value with incorrect type '#{value.class}'" unless value.instance_of?(source_class)

          instance_variable_set(var_name, value)
        end
      end
    end
  end

  module InstanceMethods
    attr_accessor :variables_history

    def history_save(name, value)
      self.variables_history ||= {}
      self.variables_history[name] ||= []
      self.variables_history[name] << value
    end

    def history_get(name)
      self.variables_history[name]
    end
  end
end

class Test
  include Accessors

  attr_accessor :variable2
  attr_accessor_with_history :variable1, :variable3
  strong_attr_accessor self, :strong_variable
end

test = Test.new
test.variable1 = 'test'
test.variable1 = 'test2'
test.variable2 = 'test'
test.variable3 = 'test3'
test.variable3 = 'test'
test.strong_variable = test
puts test.instance_variables.inspect
puts test.variable1_history.inspect
puts test.variables_history.inspect
