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
      true
    rescue RailwayError
      false
    end

    def validate!
      self.class.checks.each do |var, rules|
        var_name = "@#{var}".to_sym
        var_value = instance_variable_get(var_name)
        rules.each do |rule|
          check_type = rule[0]
          params = { value: var_value, rule: rule[1] }

          send("validate_#{check_type}", params)
        end
      end
    end

    def validate_presence(params)
      value = params[:value]
      raise RailwayError.new, "Value can't be nil or empty" if value.nil? || value.empty?
    end

    def validate_format(params)
      value = params[:value]
      rule = params[:rule]
      raise RailwayError.new, "Value doesn't match the format '#{rule}'" if value !~ rule
    end

    def validate_type(params)
      value = params[:value]
      rule = params[:rule]
      raise RailwayError.new, "Value doesn't match the type '#{rule}'" unless value.instance_of?(rule)
    end
  end
end
