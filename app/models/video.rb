class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, presence: true
  validates :available_inventory, presence: true # integer?

  def checkin
    self.available_inventory += 1
    self.save
    return self.available_inventory
  end

  def checkout
    self.available_inventory -= 1
    self.save
    return self.available_inventory
  end
end
