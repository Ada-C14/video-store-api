class Video < ApplicationRecord
  has_many :rentals
  validates :title, :overview, :release_date, :total_inventory, :available_inventory, presence: true

  def decrement_inventory
    self.available_inventory -= 1
  end

  def increment_inventory
    self.available_inventory += 1
  end
end
