class Video < ApplicationRecord
  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, numericality: true
  validates :available_inventory, numericality: true
end
