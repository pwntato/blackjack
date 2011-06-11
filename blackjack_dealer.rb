require 'blackjack_player'
require 'blackjack_hand'

class BlackjackDealer < BlackjackPlayer
  def initialize
    @hand = BlackjackHand.new
    @money = 0
  end
  
  def action(bj_table)
    @hand.bj_value < 17 ? :hit : :stand
  end
  
  def visible_cards
    @hand.cards[1..-1]
  end
  
  def can_split?
    false
  end
  
  def to_s
    "Dealer: #{@hand}: #{@hand.bj_value}"
  end
end
