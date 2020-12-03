class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, presence: true
  validates :available_inventory, presence: true

  def decrease_available_inventory
    self.available_inventory -= 1
    self.save
    return

  end

  def increase_available_inventory
    self.available_inventory += 1
    return self.save

  end
end