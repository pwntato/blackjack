class Hand
  def initialize
    @cards = []
  end

  def <<(card)
    @cards << card
  end
  
  def value
    value = 0
    @cards.each { |card| value += card.value }
    @cards.select { |card| card.card_name == :ace }.each do |card|
      value -= 10 if value > 21
    end
    value
  end

  def to_s
    @cards.join(', ')
  end
end
