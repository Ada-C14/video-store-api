class RentalsController < ApplicationController

  def check_in_rental
    if params[:video_id]
      rental =  Video.find_by(id: rental.video_id)
    else params[:customer_id]
      rental = Customer.find_by(id: rental.customer_id)
    end

    if rental.nil?
      render json: { errors: rental.errors.messages }, status: :not_found
    else
      rental.customer_id.check_in && rental.video_id.check_in
      render json: rental.as_json(only: [:customer_id, :video_id, :videos_checked_out_count, :available_inventory]), status: :ok
    end
  end

end
