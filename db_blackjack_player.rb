require 'blackjack_player'
require 'db'

class DbBlackjackPlayer < BlackjackPlayer
  def initialize(table_name)
    new_hand
    @money = 100
    @bet_size = 5
    @hands_played = 0
    @hands_won = 0
    @max_money = @money
    @db = DB.new
    @hands_per_gen = 100
    @table_name = table_name
    @db.create_organisms_table
    @db.create_organism(@table_name)
  end

  def action(table)
    situation = situation(table.dealer_cards.first)
    action = @db.action_for_situation(@table_name, situation).strip
  end
  
  def bet_or_quit
    return :quit if @hands_played == @hands_per_gen
    @money - @bet_size >= 0 ? @bet_size : :quit
  end
  
  def situation(dealer_card)
    "#{@hand.hand_key}:#{dealer_card.value}"
  end
  
  def update_stats
    @db.update_stats(@table_name, @money, @max_money)
  end
end

