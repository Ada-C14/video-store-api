class RentalsController < ApplicationController

  def checkout
    video = Video.find_by(id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])

    # call a method that will + 1 to customer's video checked out

    rental = Rental.new(
        due_date: (Date.today + 7),
        customer_id: customer.id,
        video_id: video.id,
        videos_checked_out_count: customer.videos_checked_out_count,
        available_inventory: video.available_inventory
    )

    if rental.save
      # call method to increment customer videos checked out
      rental.videos_checked_out_count = toggle_up_video_count(customer)
      # call method to decrease available inventory



    end

  end
end
