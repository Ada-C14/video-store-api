class Customer < ApplicationRecord
  has_many :rentals

  validates_presence_of :name
end
