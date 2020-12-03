class Customer < ApplicationRecord

  # unique name?
  validates :name, presence: true
  validates :registered_at, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true
  validates :videos_checked_out_count, numericality: { greater_than: 0 }
end
