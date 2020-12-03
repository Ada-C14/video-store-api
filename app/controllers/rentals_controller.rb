, class RentalsController < ApplicationController

  def checkout

    existing_customer = Customer.find_by(id: params[:customer_id])
    existing_video = Video.find_by(id: params[:video_id])

    if existing_customer.nil? || existing_video.nil?
      render json: {
          errors: ['Not Found']
      }, status: :not_found
      return
    elsif existing_video.available_inventory <= 0
      render json: {
          errors: ['Bad Request']
      }, status: :bad_request
      return
    end

    rental = Rental.new(rental_params)

    # create a new rental
    if rental.save

      rental.increase_customer_video_count
      rental.decrease_available_video_inventory
      rental.return_date

      customer = Customer.find_by(id: existing_customer.id)
      video = Video.find_by(id: existing_video.id)

      render json: {
          # rental.as_json(only: [:customer_id, :video_id, :due_date]),
          customer_id: rental.customer_id,
          video_id: rental.video_id,
          due_date: rental.due_date,
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
      }, status: :ok
      return
    end


  end

  private

  def rental_params
    return params.permit(:customer_id, :video_id)
  end

end
