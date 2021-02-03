require_relative 'player.rb'
class Dealer < Player
  BET_ERROR = 'Dealer has not enough cash to bet'

  def initialize(name = 'Dealer', bank = GameConfig::DEALER_BANK)
    super
  end

  def can_take_card?
    !hand.full? && hand.score < GameConfig::DEALER_MAX_POINTS
  end
end
