class Video < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :total_inventory, :available_inventory, numericality: { :only_integer => true, greater_than_or_equal_to: 0 }

  def checkout_update
    self.update(available_inventory: self.available_inventory - 1)
  end
end
