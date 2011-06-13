#!/usr/bin/env ruby
require 'deck'
require 'db'

ACTION_MAP_HAND = {'S' => :stand, 'H' => :hit, 'Dh' => :double, 'Ds' => :double, 'SP' => :split}
ACTION_MAP_TOTAL = {'S' => :stand, 'H' => :hit, 'Dh' => :hit, 'Ds' => :stand}

rows = {}

wiki = File.open('wiki_strategy.csv', 'r')
dealer_cards = []
wiki.gets.split.each do |dealer_card|
  dealer_cards << dealer_card
  rows["21:#{dealer_card}"] = :stand
end

while line = wiki.gets
  fields = line.split
  hand = fields[0]
  fields[1..-1].each_with_index do |field, i|
    action = ACTION_MAP_HAND[field] if hand['_']
    action = ACTION_MAP_TOTAL[field] unless hand['_']
    rows["#{hand}:#{dealer_cards[i]}"] = action
    rows["#{hand[/^\d?/].to_i + 11}_s:#{dealer_cards[i]}"] = ACTION_MAP_TOTAL[field] if hand[/^\d?_11$/]
  end
end

deck = Deck.new

(2..11).each do |card1|
  (2..11).each do |card2|
    next unless card2 > card1
    dealer_cards.each do |dealer_card|
      situation_key = "#{card1}_#{card2}:#{dealer_card}"
      rows[situation_key] = rows["#{card1 + card2}:#{dealer_card}"] unless rows[situation_key]
    end
  end
end

table_name = 'wiki_player'
db = DB.new
db.create_gene_table(table_name)
rows.each {|situation, action| db.add_gene(table_name, situation, action)}

