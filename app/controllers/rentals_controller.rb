class RentalsController < ApplicationController
  def check_out
    rental = Rental.new(rental_params)

    if rental.save
      render json: rental.as_json(only: [:id]), status: :created
    else
      render json: { errors: rental.errors.messages }, status: :bad_request
    end
  end

  private

  def rental_params
    params.permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end
end
