class Customer < ApplicationRecord
  validates :name, :registered_at, :address, :city, :state, :postal_code, :phone, presence: true
  validates :videos_checked_out_count, presence: true, numericality: { greater_than_or_equal_to: 0}
end
