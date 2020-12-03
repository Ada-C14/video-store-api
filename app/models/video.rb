class Video < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :total_inventory, :available_inventory, presence: true, numericality: { greater_than_or_equal_to: 0}
end
