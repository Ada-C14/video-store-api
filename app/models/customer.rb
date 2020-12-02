class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, :through => :rentals

  validates :name, presence: true

  def increase_video_check_out
    self.videos_checked_out_count += 1
    self.save
  end

  def decrease_video_check_out
    self.videos_checked_out_count -= 1
    self.save
  end
end
