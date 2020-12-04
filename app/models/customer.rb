class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  validates :videos_checked_out_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
