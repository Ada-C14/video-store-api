class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  def increase_checkedout_videos
    self.videos_checked_out_count += 1
    self.save
  end
end
