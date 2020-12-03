class RentalsController < ApplicationController
  def index
    rentals = Rental.all.order(:id)

    render json: rentals.as_json(only: [:id, :customer_id, :video_id, :due_date, :videos_checked_out_count,
                                        :available_inventory]), status: :ok
  end

  def show
  end

  # def check_ou
  #   new_rental = Rental.new(rental_params)
  #   new_rental
  #
  #
  # end
  # def create
  #   rental = Rental.new(rental_params)
  #   if rental.save
  #     render json: rental.as_json(only: [:id]), status: :created
  #   else
  #     render json: {
  #         errors: rental.errors.messages
  #     }, status: :bad_request
  #     return
  #   end
  # end



  def rental_params
    return params.permit(:id, :customer_id, :video_id, :due_date, :videos_checked_out_count,
                         :available_inventory)
  end
end
