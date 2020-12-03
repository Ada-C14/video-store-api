class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  validates :name, presence: true, uniqueness: true
  validates :registered_at, presence: true
  validates :postal_code, presence: true #maybe length? integer?
  validates :phone, presence: true
  validates :videos_checked_out_count, presence: true # >= 0

  def checkin
    self.videos_checked_out_count -= 1
    self.save
    return self.videos_checked_out_count
  end

  def checkout
    self.videos_checked_out_count += 1
    self.save
    return self.videos_checked_out_count
  end

end
