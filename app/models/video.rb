class Video < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :total_inventory, numericality: {only: :integer, greater_than_or_equal_to: 0 }, presence: true
  validates :available_inventory, numericality: {only: :integer, greater_than_or_equal_to: 0 }, presence: true

  def decrement_inventory
    self.available_inventory -= 1
  end

  def increment_inventory
    self.available_inventory += 1
  end

  def currently_checked_out_to
    return self.rentals.filter { |rental| rental.updated_at == rental.created_at }.map { |rental| rental.customer }
  end
end
