require_relative 'validation.rb'
require_relative 'hand.rb'
require_relative 'bank.rb'
require_relative 'game_config.rb'
require 'forwardable'
class Player
  include Validation
  extend Forwardable

  BET_ERROR = 'Player has not enough cash to bet'

  def_delegators :@hand, :add_card, :score, :fold_hand, :cards, :full?
  def_delegators :@bank, :cash_on, :cash_off, :cash, :enough_money_to_pay?

  attr_reader :name, :hand, :bank

  validate :name, type: String, presence: nil, min_length: 5, max_length: 10
  validate :bank, type: Bank
  def initialize(name, bank = GameConfig::PLAYER_BANK)
    @name = name
    @bank = Bank.new(bank)
    @hand = Hand.new
    validate!
  end

  def bet(value = GameConfig::BET_SIZE)
    player_bet_validate!(value)
    bank.cash_off(value)
  end

  def can_take_card?
    !hand.full?
  end

  def bust?
    hand.score > GameConfig::BJ
  end

  private

  def player_bet_validate!(value)
    raise self::BET_ERROR unless bank.enough_money_to_pay?(value)
  end
end
