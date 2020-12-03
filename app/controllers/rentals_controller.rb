class RentalsController < ApplicationController

  def checkout
#     increase the customer's videos_checked_out_count by one
# decrease the video's available_inventory by one
# create a due date. The rental's due date is the seven days from the current date.

    rental = Rental.new(rental_params)
    # this due date is wrong
    rental.update(due_date: Time.now.strftime("%Y-%m-%d"))
    if rental.save
      rental.customer.videos_checked_out_count += 1
      rental.video.available_inventory -= 1
      render json: {
        "customer_id": rental.customer_id,
        "video_id": rental.video_id,
        "due_date": rental.due_date,
        "videos_checked_out_count": rental.customer.videos_checked_out_count,
        "available_inventory": rental.video.available_inventory
      }, status: :ok
    #   The API should return back detailed errors and a status 404: Not Found if the customer does not exist
    #   The API should return back detailed errors and a status 404: Not Found if the video does not exist
    #   The API should return back detailed errors and a status 400: Bad Request if the video does not have any available inventory before check out
    end
  end

  private

  def rental_params
    params.permit(:customer_id, :video_id)
  end
end
