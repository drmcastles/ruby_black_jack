class Card
  RANKS = {
    '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8,
    '9' => 9, '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 1
  }
  SUITS = %w[♠ ♥ ♣ ♦]

  attr_reader :rank, :suit, :value
  def initialize(rank, suit, value)
    @rank = rank
    @suit = suit
    @value = value
  end

  def ace?
    rank == 'A'
  end
end
