class BlackjackPlayer
  def initialize
    @hand = Hand.new
    @money = 100
  end
  
  def <<(card)
    @hand << card
  end
  
  def action(bj_table)
    puts "Dealer: #{bj_table.dealer_cards.each { |card| card.to_s }}"
    puts "#{@hand}: #{@hand.bj_value}"
    puts "Money: #{@money}"
    table.options.each_with_index do |option, i|
      puts "#{i}) option"
    end
    puts "What would you like to do: "
    table.options[gets]
  end
  
  def new_hand
    @hand = Hand.new
  end
  
  attr_reader: :hand
  attr_accessor: :money
end
