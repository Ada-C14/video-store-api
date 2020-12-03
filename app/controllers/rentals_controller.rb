class RentalsController < ApplicationController
  def check_out
    rental = Rental.new(video: @video, customer: @customer ,due_date: Time.now + 7 )

  end

  def check_in

  end

  private

  def find_customer
    @customer = Customer.find_by(id: params[:id])
  end

  def find_video
    @video = Video.find_by(id: params[:id])
  end
end
