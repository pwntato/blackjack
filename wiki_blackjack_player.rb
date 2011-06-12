require 'blackjack_player'

class WikiBlackjackPlayer < BlackjackPlayer
  STRATEGY = {
              '2:2_2' => :split
             }
  
  def initialize
    new_hand
    @money = 100
    @bet_size = 5
  end

  def action(table)
    puts situation_key(table.dealer_cards.first)
    :stand
  end
  
  def bet_or_quit
    @money - @bet_size >= 0 ? @bet_size : :quit
  end
  
  def situation_key(dealer_card)
    "#{hand_key}:#{dealer_card.value}"
  end
  
  def hand_key
    @hand.cards.sort_by(&:value).map{|card|card.value}.join('_')
  end
end

