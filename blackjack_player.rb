require 'blackjack_hand'

class BlackjackPlayer
  def initialize
    new_hand
    @money = 100
  end
  
  def <<(card)
    @hand << card
  end
  
  def action(table)
    puts "\nDealer: #{table.dealer_cards.each { |card| card.to_s }}"
    puts "Hand #{hand_number+1}: #{@hand}: #{@hand.bj_value}"
    puts "Money: #{@money}\n"
    table.options.each_with_index do |option, i|
      puts "#{i+1}) #{option}"
    end
    puts "What would you like to do: "
    table.options[gets.to_i-1]
  end
  
  def split
    return unless can_split?
    @hands << @hand.split
  end
  
  def can_split?
    @hands.length < 4 and @hand.is_pair?
  end
  
  def next_hand
    @hand = @hands[hand_number + 1] || nil
  end
  
  def hand_number
    @hands.index(@hand)
  end
  
  def new_hand
    @hand = BlackjackHand.new
    @hands = [ @hand ]
  end
  
  def can_afford(bets, new_bet)
    total = new_bet
    bets.each {|bet| total += bet}
    money - total > 0
  end
  
  def to_s(number=hand_number)
    "Hand #{number+1}: #{@hands[number]}: #{@hands[number].bj_value}"
  end
  
  attr_reader :hand, :hands
  attr_accessor :money
end

