require_relative 'validation.rb'
class Bank
  include Validation

  NEGATIVE_VALUE_ERROR = 'Value must be positive!'
  VALUE_TYPE_ERROR = 'Value must be Integer!'
  CASH_NULL_ERROR = 'Bank is empty!'
  CASH_VALUE_ERROR = 'Cash off value is to high!'

  attr_reader :cash

  validate :cash, type: Integer, positive: nil
  def initialize(cash)
    @cash = cash
    validate!
  end

  def cash_on(amount)
    cash_on_validate!(amount)
    @cash += amount
  end

  def cash_off(amount)
    cash_off_validate!(amount)
    @cash -= amount
    amount
  end

  def enough_money_to_pay?(amount)
    cash - amount >= 0
  end

  private

  def cash_on_validate!(amount)
    raise VALUE_TYPE_ERROR unless amount.is_a? Integer
    raise NEGATIVE_VALUE_ERROR if amount.negative?
  end

  def cash_off_validate!(amount)
    cash_on_validate!(amount)
    raise CASH_NULL_ERROR if cash.zero?
    raise CASH_VALUE_ERROR if (cash - amount).negative?
  end
end
