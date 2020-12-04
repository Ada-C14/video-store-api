class Customer < ApplicationRecord
  has_many :rentals

  validates :name, :registered_at, :address, :city, :state, :phone, :postal_code, presence: true
  validates :videos_checked_out_count, numericality: {only: :integer, greater_than_or_equal_to: 0 }, presence: true

  def increment_checkout_count
    self.videos_checked_out_count += 1
  end

  def decrement_checkout_count
    self.videos_checked_out_count -= 1
  end
end
