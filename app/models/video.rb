class Video < ApplicationRecord
  validates :title,
            presence: true
  validates :overview,
            presence: true
  validates :release_date,
            presence: true
  validates :total_inventory,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :available_inventory,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  has_many :customers, through: :rentals
end
