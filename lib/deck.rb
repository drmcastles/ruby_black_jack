require_relative 'card.rb'
class Deck
  EMPTY_DECK_ERROR = 'Deck is empty!'

  attr_reader :cards

  def initialize
    @cards = []
    Card::RANKS.each do |rank, value|
      Card::SUITS.each do |suit|
        cards << Card.new(rank, suit, value)
      end
    end
  end

  def draw_card
    cards_validate!
    cards.shift
  end

  def shuffle
    @cards = cards.shuffle
  end

  def cards?
    cards_validate!
    true
  rescue
    false
  end

  private

  def cards_validate!
    raise EMPTY_DECK_ERROR if cards.empty?
  end
end
