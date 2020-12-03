class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates_presence_of :title, :release_date, :overview, :total_inventory, :available_inventory

  validates :available_inventory, :total_inventory, numericality: { greater_than_or_equal_to: 0 }

  def available?
    return true if available_inventory > 0 && available_inventory.present?
  end
end
