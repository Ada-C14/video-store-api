class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  validates :video_id, presence: true
  validates :customer_id, presence: true


  #TODO: need to make these work
  def self.checkout(customer, video)
    self.due_date = Date.current + 7
    self.save
    customer.videos_checked_out_count += 1
    customer.save
    video.available_inventory -= 1
    video.save
    return #self #customer.videos_checked_out_count, video.available_inventory
  end

  def checkin
    rental = Rental.find_by(params[:customer_id], video_id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])
    if customer && video
      customer.videos_checked_out_count -= 1
      customer.save
      video.available_inventory += 1
      video.save
    else
      return nil
    end
    return {
      customer_id: customer.id,
      video_id: video.id,
      due_date: rental.due_date,
      videos_checked_out_count: customer.videos_checked_out_count,
      available_inventory: video.available_inventory
    }
  end

end
