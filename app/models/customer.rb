class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  validates :name, presence: true, uniqueness: true
  validates :registered_at, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :videos_checked_out_count, numericality: true, numericality: { greater_than_or_equal_to: 0 }

  def check_out
    self.videos_checked_out_count += 1
    save
  end

  def check_in
    self.videos_checked_out_count -= 1
    save
  end
end
