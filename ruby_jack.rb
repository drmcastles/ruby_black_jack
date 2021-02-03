require_relative 'lib/deck.rb'
require_relative 'lib/player.rb'
require_relative 'lib/dealer.rb'
require_relative 'lib/game_bank.rb'
require_relative 'lib/game_config.rb'
require_relative 'lib/interface.rb'
class RubyJack
  def game
    loop do
      return unless players_have_enough_money_to_pay?

      initial_game
      round
      reward(determine_winner)
      end_game
      return unless try_again?
    end
  rescue RuntimeError => e
    @interface.show_message(e.message)
    end_game
    game_bank.refund(player, dealer)
    retry
  end

  private

  attr_reader :deck, :dealer, :player, :game_bank

  def initialize
    @interface = Interface.new
    @dealer = Dealer.new
    @player = Player.new(@interface.create_player_name)
    @game_bank = GameBank.new
  end

  def try_again?
    action = @interface.show_yes_no_menu
    action == Interface::YES_NO_MENU[:yes]
  end

  def players_have_enough_money_to_pay?
    unless player.enough_money_to_pay?(GameConfig::BET_SIZE)
      @interface.show_message(Player::BET_ERROR)
      return false
    end
    unless dealer.enough_money_to_pay?(GameConfig::BET_SIZE)
      @interface.show_message(Dealer::BET_ERROR)
      return false
    end
    true
  end

  def initial_game
    @deck = Deck.new
    deck.shuffle
    game_bank.make_bets(player, dealer)
    2.times do
      dealer.add_card(deck.draw_card)
      player.add_card(deck.draw_card)
    end
    show_table('closed')
  end

  def round
    loop do
      action = player_turn
      return if action == Interface::PLAYER_TURN[:open_cards]

      dealer_turn
      show_table('closed')
      return if player.full? && dealer.full?
    end
  end

  def player_turn
    action = @interface.show_player_turn_menu
    if player.can_take_card? && action == Interface::PLAYER_TURN[:hit]
      player.add_card(deck.draw_card)
    end
    action
  end

  def dealer_turn
    dealer.add_card(deck.draw_card) if dealer.can_take_card?
  end

  def determine_winner
    return if player.bust? && dealer.bust?
    return if player.score == dealer.score
    return player if dealer.bust?
    return dealer if player.bust?
    [player, dealer].max_by(&:score)
  end

  def reward(winner)
    show_table('open')
    if winner.nil?
      @interface.show_message('Standoff!')
      game_bank.refund(player, dealer)
    else
      @interface.show_message("#{winner.name} win!")
      game_bank.reward_winner(winner)
    end
    show_player_balance
  end

  def end_game
    player.fold_hand
    dealer.fold_hand
  end

  def show_table(option)
    @interface.show_name(dealer.name)
    @interface.show_score(dealer.score, option)
    @interface.show_hand(dealer.cards, option)
    @interface.show_hand_open(player.cards)
    @interface.show_name(player.name)
    @interface.show_score(player.score, 'open')
  end

  def show_player_balance
    @interface.show_balance(player.cash)
  end
end
