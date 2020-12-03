class RentalsController < ApplicationController
  # def create
  # end

  def check_out

  end

  def check_in

  end


  def rental_params
    params.require(:rental).permit(:customer_id, :video_id)
  end
end
