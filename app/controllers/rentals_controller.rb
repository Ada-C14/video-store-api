class RentalsController < ApplicationController

  def checkout
    video = Video.find_by(id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])
    rental = Rental.new(
        due_date: (Date.today + 7),
        customer_id: customer.id,
        video_id: video.id,
        videos_checked_out_count: customer.videos_checked_out_count,
        available_inventory: video.available_inventory
    )

    if rental.save
      # call method to increment customer videos checked out
      rental.videos_checked_out_count = customer.toggle_up_video_count
      # # call method to decrease available inventory
      rental.available_inventory = video.toggle_down_inventory
      render json: rental.as_json(only: [:customer_id, :video_id, :due_date, :videos_checked_out_count, :available_inventory]),
             status: :created
      return
    else
      render json: { errors: rental.errors.messages }, status: :bad_request
      return
    end

  end
end
