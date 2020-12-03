class RentalsController < ApplicationController
  def checkin
    rental = Rental.find_by(video_id: params[:video_id], customer_id: params[:customer_id], return_date: nil)

    if rental.nil?
      render json: {
          errors: [
              "Not Found"
          ]
      }, status: :not_found
      return
    end

    if rental
      video = rental.video
      video.available_inventory += 1
      video.save
      available_inventory = rental.video.available_inventory

      customer = rental.customer
      if customer.videos_checked_out_count <= 0
        render json: {
            errors: rental.errors.messages
        }, status: :not_found
        return
      else
        customer.videos_checked_out_count -= 1
        customer.save
        videos_checked_out_count = rental.customer.videos_checked_out_count
      end

      rental.return_date = Date.today
      puts rental.return_date

      rental_view = rental.as_json(only: [:customer_id, :video_id])
      rental_view[:videos_checked_out_count] = videos_checked_out_count
      rental_view[:available_inventory] = available_inventory

      render json: rental_view,
             status: :ok
    else
      render json: {
          errors: rental.errors.messages
      }, status: :not_found
      return
    end
  end
  

  private
  def rental_params
    return params.permit(:customer_id, :video_id)
  end
end
