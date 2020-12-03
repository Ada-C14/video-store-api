class RentalsController < ApplicationController

  def checkout
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil? || video.nil?
      render json: { 'errors': ['Not Found'] }, status: :not_found
      return
    else
      rental = Rental.create(
          customer_id: params[:customer_id],
          video_id: params[:video_id],
          due_date: Time.now + (60*60*24*7)
      )
    end
  end
end
