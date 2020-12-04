class Customer < ApplicationRecord
  has_many :rentals
  has_many :videos, through: :rentals

  validates :name, presence: true

  def increase_checkedout_videos
    self.videos_checked_out_count += 1
    self.save
    return videos_checked_out_count
  end

  def decrease_checkedout_videos
    self.videos_checked_out_count -= 1
    self.save
    return videos_checked_out_count
  end
end
