#!/usr/bin/env ruby
require 'deck'
require 'card'
require 'blackjack_hand'
require 'blackjack_table'
require 'blackjack_dealer'
require 'blackjack_player'
require 'db_blackjack_player'
require 'wiki_blackjack_player'

#player = BlackjackPlayer.new
#player = WikiBlackjackPlayer.new
player = DbBlackjackPlayer.new('wiki_player')
dealer = BlackjackDealer.new
bet = 0
deck = Deck.new
deck.shuffle!

while player.money - 5 >= 0 do
  player.new_hand
  dealer.new_hand
  puts "\nYou have: $#{player.money}"
  choice = player.bet_or_quit
  break if choice == :quit
  bet = [choice]
  player.money -= bet.last
  deck.shuffle!
  
  # deal
  table = BlackjackTable.new
  2.times do
    dealer << deck.deal
    player << deck.deal
  end
  table.dealer_cards = dealer.visible_cards
  
  # check blackjack situation
  if dealer.hand.bj_value == 21
    player.hands_played += 1
    puts "\nDealer has blackjack"
    if player.hand.bj_value == 21
      puts "PUSH: You have blackjack too"
      next
    else
      puts "You lose"
      next
    end
  end
  
  loop do
    table.current_bet = bet[player.hand_number]
    table.options = [ :hit, :stand, :double ]
    while player.hand.bj_value < 21
      # can split
      if player.can_split? and player.money - bet[player.hand_number] >= 0
        table.options << :split unless table.options.index(:split)
      else
        table.options -= [:split]
      end
      # can double
      unless player.money - bet[player.hand_number] >= 0
        table.options -= [:double]
      end
      
      case player.action(table).to_s
        when 'hit'
          player << deck.deal
          table.options -= [ :double ]
        when 'stand'
          break
        when 'split'
          bet << bet[player.hand_number]
          player.money -= bet.last
          player.split
          player << deck.deal
          player.hands.last << deck.deal
          player.hands.each_with_index do |hand, i|
            puts player.to_s(i)
          end
        when 'double'
          player.money -= bet[player.hand_number]
          bet[player.hand_number] *= 2
          player << deck.deal
          break
        else
          puts "unkown action"
      end
    end
    
    puts player.to_s if player.hands.length > 1
    
    break unless player.next_hand
  end  
  
  if player.hands.reject {|hand| hand.bj_value > 21 or hand.is_blackjack?}.any?
    while dealer.hand.bj_value < 21
      case dealer.action(table)
        when :hit
          dealer << deck.deal
        when :stand
          break
      end
    end
  end
  
  player.hands.each_with_index do |hand, i|
    player.hands_played += 1
    puts "\n#{dealer.to_s}"
    puts player.to_s(i)
    if hand.bj_value > 21
      puts "    You lose: Busted"
    elsif dealer.hand.bj_value > 21
      puts "    YOU WIN $#{bet[i]}: Dealer busted"
      player.money += bet[i] * 2
      player.hands_won += 1
    elsif hand.is_blackjack?
      puts "    YOU WIN $#{bet[i]}: Blackjack"
      player.money += bet[i] * 2      
      player.hands_won += 1
    elsif hand.bj_value > dealer.hand.bj_value
      puts "    YOU WIN $#{bet[i]}"
      player.money += bet[i] * 2
      player.hands_won += 1
    elsif hand.bj_value < dealer.hand.bj_value
      puts "    You lose"
    else 
      puts "PUSH"
      player.money += bet[i]
    end
  end
  player.max_money = [player.money, player.max_money].max
end

puts "\nHands played: #{player.hands_played}"
puts "Hands won: #{player.hands_won}"
puts "Max money: #{player.max_money}"
puts "Final winnings: #{player.money}"
player.update_stats

player.make_baby













