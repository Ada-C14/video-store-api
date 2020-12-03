class RentalsController < ApplicationController

  def index
    rentals = Rental.all.as_json(only: [:customer_id, :video_id, :checkout_date, :due_date, :status])
    render json: rentals, status: :ok
  end

end

