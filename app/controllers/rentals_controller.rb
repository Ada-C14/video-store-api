class RentalsController < ApplicationController

  def checkout
    rental = Rental.new(rental_params)
    rental.assign_attributes(due_date: (Time.now + 7.days).strftime("%Y-%m-%d"))
    if rental.valid? && rental.customer.update_video_count
      if rental.video.checkout
        rental.save
        rental_info = rental.as_json(
          only: [:customer_id, :video_id, :due_date]).merge(
          videos_checked_out_count: rental.customer.videos_checked_out_count,
          available_inventory: rental.video.available_inventory
          )
        render json: rental_info, status: :ok
      else
        render json: {ok: false, errors: rental.video.errors.messages}, status: :bad_request
      end
    else
      render json: {ok: false, errors: rental.errors.messages}, status: :not_found
    end
  end

  private

  def rental_params
    params.permit(:customer_id, :video_id)
  end
end
