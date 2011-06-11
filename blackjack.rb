#!/usr/bin/env ruby
require 'deck'
require 'card'
require 'blackjack_hand'
require 'blackjack_table'
require 'blackjack_dealer'
require 'blackjack_player'

player = BlackjackPlayer.new
dealer = BlackjackDealer.new
bet = 0
deck = Deck.new
deck.shuffle!

while player.money - 5 > 0 do
  player.new_hand
  dealer.new_hand
  puts "\nYou have: $#{player.money}"
  choice =''
  until choice.to_i > 0 or choice[/quit/i]
    puts "Enter a bet or exit to quit: "
    choice = gets
  end
  break if choice[/quit/i]
  deck.shuffle!
  bet = [ choice.to_i ]
  
  # deal
  table = BlackjackTable.new
  2.times do
    dealer << deck.deal
    player << deck.deal
  end
  table.dealer_cards = dealer.visible_cards
  
  # check blackjack situation
  if dealer.hand.bj_value == 21
    puts "\nDealer has blackjack"
    if player.hand.bj_value == 21
      puts "Draw: You have blackjack too"
      next
    else
      puts "You lose: You do not have blackjack"
      player.money -= bet[0]
      next
    end
  end
  
  loop do
    table.options = [ :hit, :stand, :double ]
    while player.hand.bj_value < 21
      player.can_split? ? table.options << :split : table.options - [:split]
      case player.action(table)
        when :hit
          player << deck.deal
          table.options -= [ :double ]
        when :stand
          break
        when :split
          if player.split and player.can_afford(bet, bet[player.hand_number])
            bet << bet[player.hand_number]
            player << deck.deal
            player.hands.last << deck.deal
            player.hands.each_with_index do |hand, i|
              puts player.to_s
            end
          end
        when :double
          if player.can_afford(bet, bet[player.hand_number])
            bet[player.hand_number] *= 2
            player << deck.deal
            break
          end
      end
    end
    
    break unless player.next_hand
  end  
  
  if player.hands.select {|hand| hand.bj_value <= 21}.any?
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
    puts "\n#{dealer.to_s}"
    puts player.to_s(i)
    if hand.bj_value > 21
      puts "    BUSTED"
      player.money -= bet[i]
    elsif dealer.hand.bj_value > 21
      puts "    YOU WIN: Dealer busted"
      player.money += bet[i]
    elsif hand.bj_value > dealer.hand.bj_value
      puts "    YOU WIN"
      player.money += bet[i]
    elsif hand.bj_value < dealer.hand.bj_value
      puts "    You lose"
      player.money -= bet[i]
    else 
      puts "PUSH"
    end
  end
end

















