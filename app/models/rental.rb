class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  def checkout

    customer.videos_checked_out_count += 1
    customer.save!

    video.available_inventory -= 1
    video.save!
    save
  end

  def checkin

    customer.videos_checked_out_count -= 1
    customer.save!

    video.available_inventory += 1
    video.save!
    save
  end


end

