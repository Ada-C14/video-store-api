class Customer < ApplicationRecord

  has_many :rentals
  has_many :videos, through: :rentals

  # unique name?
  validates :name, presence: true
  validates :registered_at, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true
  validates :videos_checked_out_count, numericality: { greater_than: 0 }
end
