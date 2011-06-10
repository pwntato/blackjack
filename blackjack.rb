#!/usr/bin/env ruby
require 'deck'
require 'card'
require 'hand'

deck = Deck.new
deck.shuffle

hand = Hand.new
2.times { |i| hand << deck.deal }

puts "#{hand}: #{hand.value}"

