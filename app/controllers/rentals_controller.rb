class RentalsController < ApplicationController
  def check_out
    rental = Rental.new(rental_params)
    rental.due_date = Date.today + 7.days

    if rental.video && rental.video.available_inventory < 1
      render json: {
        ok: false,
        errors: ["Not enough available inventory"]
      }, status: :bad_request
      return
    end
    
    if rental.save
      rental.customer.increment_checkout_count
      rental.video.decrement_inventory

      json_to_return = rental.as_json(only: [:customer_id, :video_id, :due_date])
      json_to_return[:videos_checked_out_count] = rental.customer.videos_checked_out_count
      json_to_return[:available_inventory] = rental.video.available_inventory

      render json: json_to_return, status: :ok
      return
    else
      render json: {
          ok: false,
          errors: rental.errors.messages
      }, status: :not_found
      return
    end
  end

  def check_in
    rental = Rental.find_by(customer_id: params[:customer_id], video_id: params[:video_id])

    if rental.nil?
      render json: {
        ok: false,
        errors: ["Invalid rental"]
      }, status: :not_found
      return
    else
      rental.customer.decrement_checkout_count
      rental.video.increment_inventory

      json_to_return = rental.as_json(only: [:customer_id, :video_id])
      json_to_return[:videos_checked_out_count] = rental.customer.videos_checked_out_count
      json_to_return[:available_inventory] = rental.video.available_inventory

      render json: json_to_return, status: :ok
      return
    end
  end

  private

  def rental_params
    params.permit(:customer_id, :video_id, :due_date)
  end


end
