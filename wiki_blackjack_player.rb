require 'db_blackjack_player'
require 'db'

class WikiBlackjackPlayer < DbBlackjackPlayer  
  def initialize
    new_hand
    @money = 100
    @bet_size = 5
    @hands_played = 0
    @hands_won = 0
    @max_money = @money
    @db = DB.new
    @table_name = 'wiki_player'
    @hands_per_gen = -1
  end
  
  def update_stats 
  end
end

