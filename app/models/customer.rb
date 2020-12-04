class Customer < ApplicationRecord
  has_many :rentals

  validates :name, :registered_at, :address, :city, :state, :postal_code, :phone, presence: true
  validates :videos_checked_out_count, presence: true, numericality: { greater_than_or_equal_to: 0}

  def update_checked_out
    self.videos_checked_out_count += 1
    self.save!
  end

  def update_checked_in
    self.videos_checked_out_count -= 1
    self.save!
  end
end
