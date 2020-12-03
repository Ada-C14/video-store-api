class RentalsController < ApplicationController
  # def create
  # end

  def check_out

  end

  def check_in
    customer = Customer.find_by(id: rental_params[:customer_id])
    video = Video.find_by(id: rental_params[:video_id])
    rental = Rental.find_by(customer_id: customer.id, video_id: video.id)

    rental.check_in = Time.now

    if rental.nil?
      render json: {
          ok: false,
          message: 'Not Found'
      }, status: :not_found
      return
    end

    if customer && video
      customer.videos_checked_out_count -= 1
      rental.video.available_inventory += 1

      render json: rental.as_json(only: [:id]), status: :ok
      return
    else
      render json: {
          ok: false,
          errors: rental.errors.messages
      }, status: :bad_request
      return
    end
  end


  private

  def rental_params
    params.require(:rental).permit(:customer_id, :video_id)
  end
end
