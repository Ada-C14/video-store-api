class RentalsController < ApplicationController

  # def check_in
  #   customer = Customer.
  # end



  private

  def rental_params
    return params.permit(:video_id, :customer_id)
  end
end
