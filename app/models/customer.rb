class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  validates :name, :address, :city, :state, :postal_code, :phone, :registered_at, presence: true
  validates :videos_checked_out_count, numericality: { greater_than_or_equal_to: 0 }
end

