class RentalsController < ApplicationController
  before_action :find_rental, only: [:update]

  def index

  end

  def update
    if rental
  end


  private

  def rental_params
    params.permit(:video_id, :customer_id)
  end

  def find_rental
    rental = Rental.find_by(id: params[:id])
    if rental.nil?
      render json: {ok: false, errors: "Not Found"}, status: :not_found
    end
  end
end
