class Video < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :total_inventory, numericality: { :only_integer => true, greater_than_or_equal_to: 0 }
  validates :available_inventory, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :total_inventory }
end
