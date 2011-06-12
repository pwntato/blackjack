class BlackjackTable
  def initialize
    @dealer_cards = []
    @options = []
    @current_bet = 0
  end
  
  attr_accessor :dealer_cards, :options, :current_bet
end

