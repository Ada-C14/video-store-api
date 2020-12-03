class Customer < ApplicationRecord
  has_many :rentals, dependent: :destroy

  #has_many :videos, through rentals
end
