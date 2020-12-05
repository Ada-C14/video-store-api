class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  validates :customer_id, presence: true
  validates :video_id, presence: true
  validates :checkout_date, presence: true
  validates :due_date, presence: true


  def self.check_out(video, customer)
    # is available_inventory > 0?
    return nil unless video.available_inventory >= 1

    time = DateTime.now
    # time = Date.today
    due_date = time + 7.days

    # create a rental
    new_rental = Rental.create(customer_id: customer.id, video_id: video.id, checkout_date: time, due_date: due_date)

    # decrement the available_inventory of video
    new_rental.video.available_inventory -= 1
    new_rental.video.save

    # increment the video_checkout_count of customer
    new_rental.customer.videos_checked_out_count += 1
    new_rental.customer.save

    return new_rental
  end

  def check_in
    return false if checked_in_date

    video.available_inventory += 1
    video.save
    customer.videos_checked_out_count -= 1
    customer.save
    self.checked_in_date = DateTime.now
    return self.save
  end

  def self.find_rental(video,customer)
    rental = Rental.find_by(video: video, customer: customer, checked_in_date: nil )
  end

end
