class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  # validates :customer_id, presence: true
  # validates :video_id, presence: true

  def checked_in_time
    if self.customer_id.check_in && self.video_id.check_in
      return self.checked_in
     end
    self.save
  end
end
