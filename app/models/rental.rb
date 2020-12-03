class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  # validates :customer_id, presence: true
  # validates :video_id, presence: true

  def is_valid?
    video = Video.find_by(id: self.video_id)
    
    return video.available_inventory.positive?
  end

  def initialize_rental
    Video.find_by(id: video_id).check_out
    Customer.find_by(id: customer_id).check_out
    self.checked_out = Date.today
    self.due_date = checked_out + 7
    save
  end

  def checked_in_time
    if customer_id.check_in && video_id.check_in
      return checked_in
     end
    save
  end
end
