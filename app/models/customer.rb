class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals
end
