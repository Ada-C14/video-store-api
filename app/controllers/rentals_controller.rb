class RentalsController < ApplicationController

  def check_out
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil? || video.nil?
      render json: {
          errors: ["Not Found"]
      }, status: :not_found
    elsif video.available_inventory < 1
      render json: {
          errors: ["Bad Request"]
      }, status: :bad_request
    else
      rental = Rental.new(rental_params)

      if rental.save
        customer.increase_videos_checked_out
        video.decrease_available_inventory
        render json: {
            customer_id: customer.id,
            video_id: video.id,
            due_date: Date.today + 1.week,
            videos_checked_out_count: customer.videos_checked_out_count,
            available_inventory: video.available_inventory
        },
               status: :ok
        return
      end
    end
  end

  def check_in
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil? || video.nil?
      render json: {
          errors: ["Not Found"]
      }, status: :not_found
    else
      customer.decrease_videos_checked_out
      video.increase_available_inventory
      render json: {
          customer_id: customer.id,
          video_id: video.id,
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
      }, status: :ok
    end
  end

  def rental_params
    return params.permit(:customer_id, :video_id)
  end
end
