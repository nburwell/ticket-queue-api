class AddQueueToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :queue, :string
    change_column :tickets, :created_at, :datetime, :null => true
    change_column :tickets, :updated_at, :datetime, :null => true

    add_index :tickets, [:queue]
  end

  def self.down
    remove_column :tickets, :queue
    change_column :tickets, :created_at, :datetime, null: false
    change_column :tickets, :updated_at, :datetime, null: false

    remove_index :tickets, :name => :index_tickets_on_queue rescue ActiveRecord::StatementInvalid
  end
end
