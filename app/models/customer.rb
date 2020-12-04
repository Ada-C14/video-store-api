class Customer < ApplicationRecord
  has_many :rentals
  validates_presence_of :name

  def update_video_count
    self.videos_checked_out_count += 1
    self.save
  end

  def decrease_video_count
    self.videos_checked_out_count -= 1
    self.save
  end
end
