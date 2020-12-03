class Customer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :registered_at, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :videos_checked_out_count, numericality: true #not sure about this? customer can have 0 checked out

  has_many :videos, through: :rentals



end
