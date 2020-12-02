class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates_presence_of :title, :release_date, :overview, :total_inventory, :available_inventory

  validates :available_inventory, :total_inventory, numericality: { greater_than_or_equal_to: 0 }

  validate :release_date_cannot_be_in_future

  def release_date_cannot_be_in_future
    if release_date.present? && release_date > DateTime.now
      errors.add(:release_date, "can't be in the future")
    end
  end
end
