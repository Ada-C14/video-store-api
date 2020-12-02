class RentalsController < ApplicationController

  def checkout
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])
  end
end
