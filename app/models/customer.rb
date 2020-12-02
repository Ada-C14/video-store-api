class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  validates_presence_of :name, :registered_at, :videos_checked_out_count

  validates :videos_checked_out_count, numericality: { greater_than_or_equal_to: 0 }
end
