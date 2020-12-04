class Customer < ApplicationRecord
  has_many :rentals, dependent: :destroy

end
