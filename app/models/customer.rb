class Customer < ApplicationRecord
  validates :name, :registered_at, :address, :city, :state, :postal_code, :phone, :videos_checked_out_count, presence: true
end
