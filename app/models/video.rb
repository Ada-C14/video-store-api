class Video < ApplicationRecord
  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :available_inventory, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "This video is out of stock"}
  has_many :rentals, dependent: :destroy

  # has_many :customers, :through => rentals
end

# def available_inventory
#   curr_rentals = self.rentals.select {
#       |rental| rental.checked_out == true
#   }
#   return self.inventory - curr_rentals.length
# end