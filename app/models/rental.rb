class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  validates :customer_id, presence: true
  validates :video_id, presence: true
  validates :checkout_date, presence: true
  validates :due_date, presence: true


  def self.checkout(video, customer)
    # is available_inventory > 0?
    return nil unless video.available_inventory >= 1

    time = DateTime.now
    # time = Date.today
    due_date = time + 7.days

    # create a rental
    new_rental = Rental.create(customer_id: customer.id, video_id: video.id, checkout_date: time, due_date: due_date)

    # decrement the available_inventory of video
    video.available_inventory -= 1
    video.save

    # increment the video_checkout_count of customer
    customer.videos_checked_out_count += 1
    customer.save

    return new_rental
  end

end
