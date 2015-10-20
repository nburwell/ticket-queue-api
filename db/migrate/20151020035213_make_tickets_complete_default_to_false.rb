class MakeTicketsCompleteDefaultToFalse < ActiveRecord::Migration
  def self.up
    change_column :tickets, :complete, :boolean, :null => false, :default => false
  end

  def self.down
    change_column :tickets, :complete, :boolean
  end
end
