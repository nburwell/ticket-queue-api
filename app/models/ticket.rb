class Ticket < ActiveRecord::Base
  fields do
    name      :string
    queue     :string
    message   :string
    complete  :boolean, null: false, default: false

    timestamps
  end
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  index [:queue]
end
