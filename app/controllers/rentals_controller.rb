class RentalsController < ApplicationController
  def create
    rental = Rental.new(rental_params)

    if rental.save
      render json: {
        customer_id: rental.customer_id,
        video_id: rental.video_id,
        due_date: rental.due_date,
        videos_checked_out_count: rental.customer.videos_checked_out_count,
        available_inventory: rental.video.available_inventory
      }, status: :created
    end
  end

  def destroy
  end

  private

  def rental_params
    return params.require(:rental).permit(:customer_id, :video_id)
  end
end
