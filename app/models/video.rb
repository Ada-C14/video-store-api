class Video < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :total_inventory, :available_inventory, presence: true, numericality: { greater_than_or_equal_to: 0}

  def checkout_decrease_inventory
    self.available_inventory -= 1
  end

  def checkin_increase_inventory
    self.available_inventory += 1
  end

end
