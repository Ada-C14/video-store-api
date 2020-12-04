class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  def checkout

    customer.videos_checked_out_count += 1
    customer.save!

    video.available_inventory -= 1
    video.save!

    #   rental[:checked_out] = true
    #   rental[:due_date] = Date.today + 7
    #   rental[:checkin_date] = nil

    save
  end

  def checkin

    customer.videos_checked_out_count -= 1
    customer.save!

    video.available_inventory += 1
    video.save!

    #   rental[:checked_out] = false
    #   rental[:due_date] = nil
    #   rental[:checkin_date] = Date.today

    save
  end


end

