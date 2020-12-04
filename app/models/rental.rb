class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video


  def check_out(customer, video)
    customer.videos_checked_out_count += 1
    if video.available_inventory > 0
      video.available_inventory -= 1
      return true
    end
  end

  def videos_checked_out_count
    return customer.videos_checked_out_count
  end

  def available_inventory
    return video.available_inventory
  end
end
