class RentalsController < ApplicationController
  # def create
  # end

  def check_out
    video = Video.find_by_id(params[:video_id])
    rental = Rental.new(rental_params)
    if !video.nil? && video.available_inventory == 0
      render json: {
        error: "No copies of #{rental.video.title} available"
      }, status: :bad_request
      return
    else
      if rental.save
        rental.video.available_inventory -= 1
        rental.customer.videos_checked_out_count += 1
        rental.check_out = rental.created_at.to_date
        rental.due_date = rental.check_out + 7

        rental_json = rental.as_json(only: [:customer_id, :video_id, :due_date])
        rental_json[:videos_checked_out_count] = rental.customer.videos_checked_out_count
        rental_json[:available_inventory] = rental.video.available_inventory
        render json: rental_json, status: :ok
      else
        render json: {
          errors: ['Not Found']
        }, status: :not_found
      end
    end
    return
  end

  def check_in

  end


  def rental_params
    params.permit(:customer_id, :video_id)
  end
end
