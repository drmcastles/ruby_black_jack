class Interface

  PLAYER_TURN = {
    hit: 'Hit',
    stand: 'Stand',
    open_cards: 'Open cards'
  }

  YES_NO_MENU = {
    yes: 'Yes',
    no: 'No'
  }

  def create_player_name
    puts 'Enter player name'
    gets.chomp
  end

  def enter_action
    gets.to_i
  end

  def input_error
    puts 'Input error!'
  end

  def show_message(message)
    puts message
  end

  def show_menu(menu, title = nil)
    puts title if title
    menu.each_value.with_index(1) do |value, index|
      puts "#{index}. #{value}"
    end
  end

  def show_name(name)
    puts "Name: #{name};"
  end

  def show_balance(balance)
    puts "Balance: #{balance}$;"
  end

  def show_score(score, option)
    case option
    when 'open' then puts "Score: #{score};"
    when 'closed' then puts 'Score: **;'
    end
  end

  def show_player_turn_menu
    loop do
      show_menu(PLAYER_TURN, 'Player turn:')
      case enter_action
      when 1 then return PLAYER_TURN[:hit]
      when 2 then return PLAYER_TURN[:stand]
      when 3 then return PLAYER_TURN[:open_cards]
      else input_error
      end
    end
  end

  def show_yes_no_menu
    loop do
      show_menu(YES_NO_MENU, 'Try again?')
      case enter_action
      when 1 then return YES_NO_MENU[:yes]
      when 2 then return YES_NO_MENU[:no]
      else input_error
      end
    end
  end

  def show_hand(cards, option)
    case option
    when 'open' then show_hand_open(cards)
    when 'closed' then show_hand_closed(cards)
    end
  end

  def show_hand_open(cards)
    result = Array.new(5, '')
    cards.each { |card| face_up(card, result) }
    puts result
  end

  def show_hand_closed(cards)
    result = Array.new(5, '')
    face_up(cards.first, result)
    cards.drop(1).each { |_card| face_down(result) }
    puts result
  end

  def face_up(card, result)
    result[0] += card.rank == '10' ? '┏10━━┓' : "┏#{card.rank}━━━┓"
    result[1] += '┃    ┃'
    result[2] += "┃ #{card.suit}  ┃"
    result[3] += '┃    ┃'
    result[4] += card.rank == '10' ? '┗━━10┛' : "┗━━━#{card.rank}┛"
    result
  end

  def face_down(result)
    result[0] += '┏━━━━┓'
    result[1] += '┃░░░░┃'
    result[2] += '┃░░░░┃'
    result[3] += '┃░░░░┃'
    result[4] += '┗━━━━┛'
    result
  end
end
