class RentalsController < ApplicationController

  def checkout
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    rental = Rental.new(rental_params)
    rental.due_date = Date.today + 7
    if video && video.available_inventory < 1
      render json: {
          ok: false,
          errors: ["Insufficient inventory"]
      }, status: :bad_request
    else
      if rental.save
        rental.checkout_update
        render json: {
            customer_id: customer.id,
            video_id: video.id,
            due_date: rental.due_date,
            videos_checked_out_count: customer.videos_checked_out_count,
            available_inventory: video.available_inventory
        }, status: :ok
      elsif customer.nil? || video.nil?
        render json: {
            ok: false,
            errors: rental.errors.messages
        }, status: :not_found
      end
    end
  end

  def checkin

  end


  private
  def rental_params
    params.permit(:video_id, :customer_id)
  end
end
