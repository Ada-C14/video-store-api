class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates :customer_id, presence: true
  validates :video_id, presence: true

  def initialize_rental
    video.check_out
    customer.check_out
    self.checked_out = Date.today
    self.due_date = Date.today + 7
    save
  end

  def rental_checkin
    video.check_in
    customer.check_in
    self.checked_in = Date.today
    save
  end
end
