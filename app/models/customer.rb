class Customer < ApplicationRecord
  has_many :videos, through: :rentals
end
