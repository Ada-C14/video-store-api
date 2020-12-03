class Customer < ApplicationRecord
  has_many :rentals
  # has_many :videos, through: :rentals

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true, uniqueness: true
end
