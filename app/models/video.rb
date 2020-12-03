class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, presence: true
  validates :release_date, presence: true
  validates :available_inventory, presence: true # integer?
end
