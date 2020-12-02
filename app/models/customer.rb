class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  validates_presence_of :name, :registered_at, :videos_checked_out_count

  validates :videos_checked_out_count, numericality: { greater_than_or_equal_to: 0 }

  validate :registration_date_cannot_be_in_future

  def registration_date_cannot_be_in_future
    if registered_at.present? && registered_at > DateTime.now
      errors.add(:registered_at, "can't be in the future")
    end
  end
end
