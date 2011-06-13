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
    @soft = (((full_value - value) / 10) != ace_count)
    value
  end
  
  def split
    return unless is_pair?
    new_hand = BlackjackHand.new
    new_hand << @cards.shift
    new_hand
  end
  
  def is_blackjack?
    return false unless @cards.length == 2
    @cards.select{|card| card.value == 11}.any? and @cards.select{|card| card.value == 10}.any?
  end
  
  def is_pair?
    @cards.length == 2 and @cards[0].value == @cards[1].value
  end
  
  def hand_key
    if @cards.length == 2
      @cards.sort_by(&:value).map{|card|card.value}.join('_')
    else
      "#{bj_value}#{'_s' if @soft}"
    end
  end

  def to_s
    @cards.join(', ')
  end
  
  attr_reader :cards, :soft
end
