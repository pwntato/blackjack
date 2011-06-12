#!/usr/bin/env ruby
require 'deck'

wiki = File.open('wiki_strategy.csv', 'r')
dealer_cards = []
wiki.gets.split.each do |dealer_card|
  dealer_cards << dealer_card
end

rows = {}
while line = wiki.gets
  fields = line.split
  fields[1..-1].each_with_index do |field, i|
    rows["#{fields[0]}:#{dealer_cards[i]}"] = "#{field}"
  end
end

deck = Deck.new
raw_rows = {}
(2..11).to_a.permutation(2) do |card|
  dealer_cards.each do |dealer_card|
    situation_key = "#{card.join('_')}:#{dealer_card}"
    raw_rows[situation_key] = rows[situation_key] || rows["#{card[0] + card[1]}:#{dealer_card}"]
  end
end

p raw_rows.sort

