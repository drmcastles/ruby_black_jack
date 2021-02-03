require_relative 'bank.rb'
class GameBank < Bank
  def initialize
    @cash = {}
  end

  def make_bets(*players)
    players.each do |player|
      cash[player.name] = player.bet
    end
  end

  def reward_winner(winner)
    winner.cash_on(cash.values.sum)
    cash.clear
  end

  def refund(*players)
    players.each { |player| player.cash_on(cash[player.name]) }
    cash.clear
  end
end
