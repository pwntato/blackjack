class Card
  SUITS = [:spade, :heart, :club, :diamond]
  VALUES = {
            :two => 2,
            :three => 3,
            :four => 4,
            :five => 5,
            :six => 6,
            :seven => 7,
            :eight => 8,
            :nine => 9,
            :ten => 10,
            :jack => 10,
            :queen => 10,
            :king => 10,
            :ace => 11
           }

  def initialize(card_name, suit)
    raise "Invalid #{card_name}, #{suit}" unless VALUES[card_name] and SUITS.index(suit)
    @card_name = card_name
    @suit = suit
  end
  
  def value
    VALUES[@card_name]
  end
  
  def to_s
    "#{@card_name} of #{@suit}s"
  end
  
  attr_accessor :card_name, :suit
end

