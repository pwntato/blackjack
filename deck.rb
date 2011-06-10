class Deck
  def initialize
    @deck = []
    @burnt = []
    Card::SUITS.each do |suit|
      Card::VALUES.keys.each do |card_name|
        @deck << Card.new(card_name, suit)
      end
    end 
  end
  
  def deal
    card = @deck.shift
    @burnt << card
    card
  end
  
  def shuffle
    @deck += @burnt 
    @burnt = []
    7.times { |i| @deck.shuffle! }
  end
  
  def length
    @deck.length
  end
end
