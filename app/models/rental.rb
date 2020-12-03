class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  def increase_customer_video_count
    customer = self.customer
    customer.videos_checked_out_count += 1
    customer.save
  end

  def decrease_available_video_inventory
    video = self.video
    video.available_inventory -= 1
    video.save
  end

  def return_date
    self.due_date = Date.today + 7.days
    self.save
  end

end
