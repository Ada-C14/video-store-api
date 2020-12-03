class Video < ApplicationRecord
  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, presence: true, numericality: true
  validates :available_inventory, presence: true, numericality: true
end
