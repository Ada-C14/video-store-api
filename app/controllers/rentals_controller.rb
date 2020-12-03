class RentalsController < ApplicationController

  def checkout




    rental = Rental.new(rental_params)

    # create a new rental
    if rental.save
      # increase the customers video checkout count
      # decrease video available inventory
      # create due date - 7 days from current date
      render json: rental.as_json(only: [:customer_id, :video_id, :due_date]), status: :ok
      return
    else
      # invalid request
      render json: { errors: rental.errors.messages }, status: :bad_request
      return
    end


  end

  private

  def rental_params
    return params.permit(:customer_id, :video_id)
  end

end
