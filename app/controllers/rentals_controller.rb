class RentalsController < ApplicationController
  def index
    rentals = Rental.all.order(:title)

    render json: rentals.as_json(only: [:id, :customer_id, :video_id, :due_date]),
           status: :ok
  end
  #  "videos_checked_out_count":
  #   "available_inventory":

  def show
  end
end
