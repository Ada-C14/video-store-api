class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video


  def check_out(customer, video)
    if video.available_inventory > 0
      video.available_inventory -= 1
      video.save
      customer.videos_checked_out_count += 1
      customer.save
      return true
    end
  end

  def check_in(customer, video)
    if customer.videos_checked_out_count > 0
      video.available_inventory += 1
      video.save
      customer.videos_checked_out_count -= 1
      customer.save
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
