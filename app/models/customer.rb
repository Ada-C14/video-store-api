class Customer < ApplicationRecord
  has_many :rentals

  validates :name, presence: true
  validates :registered_at, presence: true
  validates :postal_code, presence: true
  validates :phone,presence: true
  validates :videos_checked_out_count, numericality:  { :only_integer => true, greater_than_or_equal_to: 0 }
  validates :address, presence: true
  validates :city, presence: true
  validates :state,presence: true
end
