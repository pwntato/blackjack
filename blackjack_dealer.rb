class BlackJackDealer << BlackjackPlayer
  def initialize
    @hand = Hand.new
    @money = 0
  end
  
  def action(bj_table)
    @hand.bj_value < 17 ? :hit : :stay
  end
  
  def visible_cards
    @hand.cards[1..-1]
  end
end
