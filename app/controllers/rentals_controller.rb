class RentalsController < ApplicationController

  def checkout
    video = Video.find_by(id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])

    if video.nil? || customer.nil?
      render json: { errors: ["Not Found"] }, status: :not_found
      return
    end

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
             status: :ok
    else
      render json: { errors: rental.errors.messages }, status: :not_found
    end

  end

  def check_in
    video = Video.find_by(id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])
    rental = Rental.find_by(video_id: video.id, customer_id: customer.id)
    binding.pry
    if video.nil? || customer.nil? || rental.nil?
      render json: { errors: ["Not Found"] }, status: :not_found
      return
    end

    rental.videos_checked_out_count = customer.toggle_down_video_count
    rental.available_inventory = video.toggle_up_inventory
    rental.due_date = nil

    render json: { customer_id: customer.id, video_id: video.id, videos_checked_out_count: customer.videos_checked_out_count, available_inventory: video.available_inventory },
           status: :ok
  end
end
