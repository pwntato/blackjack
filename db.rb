require 'rubygems'
require 'pg'

class DB
  def initialize
    @conn = PGconn.new({:dbname => 'blackjack'})       # connects as user running script
  end
  
  def create_gene_table(table_name)
    @conn.exec("drop table if exists #{table_name};")
    query = "create table #{table_name} (
            situation     char(10) PRIMARY KEY,
            action        char(10)
            );"
    @conn.exec(query)
  end
  
  def add_gene(table_name, situation, action)
    query = "insert into #{table_name} (situation, action) values ('#{situation}', '#{action}');"
    @conn.exec(query)
  end
  
  def action_for_situation(table_name, situation)
    query = "select action from #{table_name} where situation='#{situation}';"
    @conn.exec(query).first['action']
  end
end

