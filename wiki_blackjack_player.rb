require 'blackjack_player'
require 'db'

class WikiBlackjackPlayer < BlackjackPlayer
  TABLE_NAME = 'wiki_player'

  def initialize
    new_hand
    @money = 100
    @bet_size = 5
    @db = DB.new
  end

  def action(table)
    situation = situation(table.dealer_cards.first)
    action = @db.action_for_situation(TABLE_NAME, situation).strip
  end
  
  def bet_or_quit
    @money - @bet_size >= 0 ? @bet_size : :quit
  end
  
  def situation(dealer_card)
    "#{@hand.hand_key}:#{dealer_card.value}"
  end
end

