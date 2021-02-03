module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  EMPTY_NAME_ERROR = 'Name can not be empty!'
  INVALID_FORMAT_ERROR = 'Invalid format!'
  INVALID_TYPE_ERROR = 'Invalid type!'
  MIN_LENGTH_ERROR = 'Name is to short!'
  MAX_LENGTH_ERROR = 'Name is to long!'
  POSITIVE_VALUE_ERROR = 'Value must be positive!'

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(name, options)
      validations << { name: name, options: options }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |value|
        options = value[:options]
        value = instance_variable_get("@#{value[:name]}".to_sym)
        options.each do |validation, option|
          validation = "validate_#{validation}"
          send(validation, value, option)
        end
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def validate_presence(value, _option)
      raise EMPTY_NAME_ERROR if value.nil? || value.strip.empty?
    end

    def validate_min_length(value, min_length)
      raise MIN_LENGTH_ERROR if value.length < min_length
    end

    def validate_max_length(value, max_length)
      raise MAX_LENGTH_ERROR if value.length > max_length
    end

    def validate_format(value, format)
      raise INVALID_FORMAT_ERROR if value.nil? || value !~ format
    end

    def validate_type(value, type)
      raise INVALID_TYPE_ERROR unless value.is_a?(type)
    end

    def validate_positive(value, _option)
      raise POSITIVE_VALUE_ERROR unless value.positive?
    end
  end
end
