class Video < ApplicationRecord

  validates :title, presence: true, uniqueness: true
  validates :release_date, presence: true
  validates :available_inventory, presence: true, numericality: { greater_than: 0 }
end
