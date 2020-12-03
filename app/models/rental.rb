class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  # validates :customer_id, presence: true
  # validates :video_id, presence: true

  def valid_rental?

  end

  def initialize_rental
    Video.find_by(id: self.video_id).check_out
    Customer.find_by(id: self.customer_id).check_out
    self.checked_out = Date.today
    self.due_date = self.checked_out + 7
    self.save
  end

  def checked_in_time
    if self.customer_id.check_in && self.video_id.check_in
      return self.checked_in
     end
    self.save
  end
end
