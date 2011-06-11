class BlackjackHand
  def initialize
    @cards = []
    @soft = false
  end

  def <<(card)
    @cards << card
  end
  
  def bj_value
    full_value = 0
    value = 0
    @cards.each { |card| full_value += card.value }
    value = full_value
    ace_count = 0
    @cards.select { |card| card.card_name == :ace }.each do |card|
      value -= 10 if value > 21
      ace_count += 1
    end
    @soft = (((full_value - value) % 10) != ace_count)
    value
  end

  def to_s
    @cards.join(', ')
  end
  
  attr_reader: :cards, :soft
end
