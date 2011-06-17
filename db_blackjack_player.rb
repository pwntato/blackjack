require 'blackjack_player'
require 'db'

class DbBlackjackPlayer < BlackjackPlayer
  MUTATION_RATE = 0.01
  
  def initialize(table_name)
    new_hand
    @money = 100
    @bet_size = 5
    @hands_played = 0
    @hands_won = 0
    @max_money = @money
    @db = DB.new
    @hands_per_gen = 100
    @table_name = table_name
    @db.create_organisms_table
    @db.create_organism(@table_name)
  end

  def action(table)
    situation = situation(table.dealer_cards.first)
    action = @db.action_for_situation(@table_name, situation).strip
  end
  
  def bet_or_quit
    return :quit if @hands_played == @hands_per_gen
    @money - @bet_size >= 0 ? @bet_size : :quit
  end
  
  def situation(dealer_card)
    "#{@hand.hand_key}:#{dealer_card.value}"
  end
  
  def update_stats
    @db.update_stats(@table_name, @money, @max_money)
  end
  
  def make_baby
    name = new_organism_name
    @db.create_organism(name)
    @db.create_gene_table(name)
    dna = @db.get_dna(@table_name)
    mutations = dna.count * MUTATION_RATE
    (0...mutations).each do
      situation = dna.keys[rand(dna.length)]
      dna[situation] = mutate_gene(situation, dna[situation])
    end
    
    @db.add_genes(name, dna)
    
    DbBlackjackPlayer.new(name)
  end
  
  def mutate_gene(situation, action)
    hand, dealer = situation.split(':')
    hand = hand.split('_')
    options = [ :hit, :stand ]
    
    if hand.length == 2 and hand.last != 's'
      options << :double
      options << :split if hand.first == hand.last
    end
    
    options[rand*options.length]
  end
  
  def new_organism_name
    name = ''
    char_set = [('a'..'z').to_a,('A'..'Z').to_a].flatten  
    until name != '' and @db.unique_name?(name)
      name = (0..10).map{ char_set[rand(char_set.length)] }.join
    end
    
    name
  end
end

