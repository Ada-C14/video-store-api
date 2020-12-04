class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, :overview, :release_date, :total_inventory, :available_inventory, presence: true
  validates :available_inventory, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
