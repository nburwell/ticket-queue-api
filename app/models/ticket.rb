class Ticket < ActiveRecord::Base
  declare_schema do
    string :name
    string :queue
    string :message
    boolean :complete, null: false, default: false

    timestamps
  end
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  index [:queue]
end
