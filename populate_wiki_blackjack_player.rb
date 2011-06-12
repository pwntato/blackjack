#!/usr/bin/env ruby

wiki = File.open('wiki_strategy.csv', 'r')

while line = wiki.gets
  puts line
end

