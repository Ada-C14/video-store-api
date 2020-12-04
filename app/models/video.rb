class Video < ApplicationRecord
  has_many :rentals, dependent: :destroy

  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, presence: true
  validates :available_inventory, presence: true

  def decrease_available_inventory
    self.available_inventory -= 1
    self.save
  end

  def increase_available_inventory
    self.available_inventory += 1
    self.save
  end
end
