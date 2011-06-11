#!/usr/bin/env ruby
require 'deck'
require 'card'
require 'hand'

player = BlackjackPlayer.new
dealer = BlackjackDealer.new
bet = 0
deck = Deck.new
deck.shuffle!

loop do
  player.new_hand
  dealer.new_hand
  puts "You have: $#{player.money}"
  puts "Enter a bet or exit to quit: "
  choice = gets
  break if choice[/quit/i]
  deck.shuffle!
  bet = choice.to_i
  
  # deal
  table = BlackjackTable.new
  2.times do
    dealer << deck.deal
    player << deck.deal
  end
  table.dealer_cards = dealer.visible_cards
  
  # check blackjack situation
  if dealer.hand.bj_value == 21
    puts "Dealer has blackjack"
    if player.hand.bj_value == 21
      puts "Draw: You have blackjack too"
      next
    else
      puts "Lose: You do not have blackjack"
      player.money -= bet
      next
    end
  end
  
  table.options = [ :hit, :stand, :split, :double ]
  while player.hand.bj_value < 21
    action = player.action(table)
  end
end



















