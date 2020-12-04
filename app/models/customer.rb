class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  validates :name, presence: true
  validates :registered_at, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true



  def checked_out_count(amount)
    self.update(videos_checked_out_count: (self.videos_checked_out_count) + amount)
  end

end
