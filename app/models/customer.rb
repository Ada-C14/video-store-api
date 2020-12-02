class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  # validates :name, presence: true

  def increase_video_checked_out_count
    self.videos_checked_out_count += 1
    self.save
  end

  def decrease_video_checked_out_count
    self.videos_checked_out_count -= 1
    self.save
  end
end
