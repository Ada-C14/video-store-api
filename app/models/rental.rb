class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  def self.due_date
    return Date.today + 7
  end

  # def self.checkin(customer, video)
  #
  # end

  def self.checkout(customer, video)
    # decrease the video's available_inventory by one
    # increase the customer's videos_checked_out_count by one
    # create a due date. The rental's due date is the seven days from the current date.
    rental = Rental.new(customer: customer, video: video, due_date: Rental.due_date)
    begin
      Rental.transaction do

        rental.save!
        rental.customer.update_checked_out
        rental.video.checkout_decrease_inventory
      end
    rescue ActiveRecord::RecordInvalid; end
    return rental
  end
end
