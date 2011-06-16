require 'rubygems'
require 'pg'

class DB
  def initialize
    @conn = PGconn.new({:dbname => 'blackjack'})       # connects as user running script
  end
  
  def create_organisms_table
    count = @conn.exec("select count(*) from pg_tables where tablename='organisms';").first['count']
    if count.to_i == 0
      query = "create table organisms (
              table_name      char(255) PRIMARY KEY,
              generation      integer,
              gen_winnings    integer,
              total_winnings  integer,
              max_end_money   integer,
              max_money       integer,
              alive           boolean
              );"
      @conn.exec(query)
    end
  end
  
  def create_organism(table_name)
    if unique_name?(table_name)
      @conn.exec("insert into organisms (table_name, generation, gen_winnings,
                  total_winnings, max_end_money, max_money, alive) 
                  values ('#{table_name}', 0, 0, 0, 0, 0, true);")
    end
  end
  
  def unique_name?(name)
    @conn.exec("select count(*) from organisms 
                where table_name='#{name}';").first['count'].to_i == 0
  end
  
  def update_stats(table_name, end_money, max_money)
    org = @conn.exec("select * from organisms where table_name = '#{table_name}';").first
    @conn.exec("update organisms set generation=#{org['generation'].to_i + 1}, 
                gen_winnings=#{end_money}, 
                total_winnings=#{org['total_winnings'].to_i + end_money},
                max_end_money=#{[ org['max_end_money'].to_i, end_money ].max},
                max_money=#{[ org['max_money'].to_i, max_money ].max}
                where table_name = '#{table_name}';")
  end
  
  def create_gene_table(table_name)
    @conn.exec("drop table if exists #{table_name};")
    query = "create table #{table_name} (
            situation     char(10) PRIMARY KEY,
            action        char(10)
            );"
    @conn.exec(query)
  end
  
  def get_dna(table_name)
    query = "select * from #{table_name};"
    dna = {}
    @conn.exec(query).each do |result| 
      dna[result['situation'].strip] = result['action'].strip
    end
    
    dna
  end
  
  def add_gene(table_name, situation, action)
    query = "insert into #{table_name} (situation, action) values ('#{situation}', '#{action}');"
    @conn.exec(query)
  end
  
  def add_genes(table_name, dna)
    query = "insert into #{table_name} (situation, action) values " + 
            dna.map {|situation, action| "('#{situation}', '#{action}')"}.join(', ') +
            ";"
    @conn.exec(query)
  end
  
  def action_for_situation(table_name, situation)
    query = "select action from #{table_name} where situation='#{situation}';"
    @conn.exec(query).first['action']
  end
end

