class Customer < ApplicationRecord
  has_many :rentals

  validates :name, :registered_at, :address, :city, :state, :phone, :postal_code, :videos_checked_out_count, presence: true

end
