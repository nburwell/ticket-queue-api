class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :message
      t.boolean :complete

      t.timestamps null: false
    end
  end
end
