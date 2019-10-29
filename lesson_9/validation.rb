# frozen_string_literal: true

require_relative 'railway_error'

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :checks

    def save_check(name, config)
      @checks ||= {}
      @checks[name] ||= []
      @checks[name] << config
    end

    def validate(name, *config)
      save_check(name.to_sym, config)
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue RailwayError
      false
    end

    def validate!
      self.class.checks.each do |var, rules|
        var_name = "@#{var}".to_sym
        var_value = instance_variable_get(var_name)
        rules.each do |rule|
          check_type = rule[0]
          case check_type
          when :presence
            raise RailwayError.new, "Value can't be nil or empty" if var_value.nil? || var_value.empty?
          when :format
            check_rule = rule[1]
            raise RailwayError.new, "Value doesn't match the format '#{check_rule}'" if var_value !~ check_rule
          when :type
            check_rule = rule[1]
            unless var_value.instance_of?(check_rule)
              raise RailwayError.new, "Value doesn't match the type '#{check_rule}'"
            end
          else
            raise RailwayError.new, "Validate method doesn't have '#{check_type}' option"
          end
        end
      end
      true
    end
  end
end

class Test2

end

class Test
  include Validation
  validate :name, :presence
  validate :name, :format, /^[a-z0-9]{3}-?[a-z0-9]{2}$/i
  validate :number, :format, /^[a-z0-9]{3}-?[a-z0-9]{2}$/i
  validate :instance, :type, Test2
  def initialize(name, number, instance)
    @name = name
    @number = number
    @instance = instance
    puts valid?
  end
end



