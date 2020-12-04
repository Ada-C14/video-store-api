class RentalsController < ApplicationController

  def check_out
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil? || video.nil?
      render json: {
          errors: ['Not Found'],
      }, status: :not_found
      return
    end

    rental = Rental.checkout(video, customer)

    if rental
      response ={
          customer_id: rental.customer_id,
          video_id: rental.video_id,
          due_date: rental.due_date,
          videos_checked_out_count: rental.customer.videos_checked_out_count,
          available_inventory: rental.video.available_inventory
      }
      render json: response.as_json(only: [:customer_id, :video_id]), status: :ok
    else
      render json: { errors: rental.errors.messages}, status: :bad_request
    end
    end
end

private
def rental_params
  return params.permit(:video_id, :customer_id)
end
