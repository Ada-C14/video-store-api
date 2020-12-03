class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, :overview, :release_date, :total_inventory, :available_inventory, presence: true
end
