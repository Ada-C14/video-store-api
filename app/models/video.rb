class Video < ApplicationRecord

  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, presence: true, numericality: :only_integer
  validates :available_inventory, presence: true, numericality: :only_integer
end
