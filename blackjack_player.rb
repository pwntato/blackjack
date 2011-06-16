require 'blackjack_hand'

class BlackjackPlayer
  def initialize
    new_hand
    @money = 100
    @hands_played = 0
    @hands_won = 0
    @max_money = @money
  end
  
  def <<(card)
    @hand << card
  end
  
  def action(table)
    puts "\nDealer: #{table.dealer_cards.each { |card| card.to_s }}"
    puts "Hand #{hand_number+1}: #{@hand}: #{@hand.bj_value}"
    puts "Money: #{@money}"
    puts "Bet: #{table.current_bet}\n"
    table.options.each_with_index do |option, i|
      puts "#{i+1}) #{option}"
    end
    choice = 0
    until choice > 0 and choice <= table.options.length
      puts "What would you like to do: "
      choice = gets.to_i
    end
    table.options[choice-1]
  end
  
  def bet_or_quit
    choice = ''
    until (choice.to_i >= 5 and choice.to_i <= @money) or choice[/quit/i]
      puts "Enter a bet ($5 - $#{@money}), quit, or nothing to bet $5: "
      choice = gets
      choice = '5' if choice.chomp == ''
    end
    choice[/quit/i] ? :quit : choice.to_i
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
  
  def to_s(number=hand_number)
    "Hand #{number+1}: #{@hands[number]}: #{@hands[number].bj_value}"
  end
  
  def update_stats
  end
  
  attr_reader :hand, :hands
  attr_accessor :money, :max_money, :hands_played, :hands_won
end

