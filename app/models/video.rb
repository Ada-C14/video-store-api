class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, numericality: { only_integer: true, greater_than: -1}
  validates :available_inventory, numericality: { only_integer: true, greater_than: -1}

  def available_inventory_update(amount)
    self.update(available_inventory: (self.available_inventory) + amount)
  end

end
