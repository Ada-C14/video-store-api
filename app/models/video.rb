class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :available_inventory, numericality: { only_integer: true, greater_than: -1}
  validates :available_inventory, numericality: { only_integer: true, greater_than: -1}

end
