require_relative 'card.rb'
require_relative 'game_config.rb'
class Hand
  include GameConfig

  ACE_CORRECTION = 10

  attr_reader :cards

  def initialize
    @cards = []
  end

  def add_card(card)
    cards << card
  end

  def fold_hand
    cards.clear
  end

  def full?
    cards.size == 3
  end

  def score
    sum = cards.map(&:value).sum
    cards.each do |card|
      if card.ace? && sum + ACE_CORRECTION <= GameConfig::BJ
        sum += ACE_CORRECTION
      end
    end
    sum
  end
end
