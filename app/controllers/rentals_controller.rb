class RentalsController < ApplicationController
  def check_out
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])
    if customer.nil? || video.nil?
      render json: {
          "errors": [
              "Not Found"
          ]
      }, status: :not_found
      return
    end

    rental = Rental.new(customer_id: customer.id, video_id: video.id, due_date: Date.today + 7.days)

    if rental.check_out_video
      # merge is a Hash method
      render json: rental.as_json(only: [:customer_id, :video_id, :due_date]).merge(
          videos_checked_out_count: rental.customer.videos_checked_out_count,
          available_inventory: rental.video.available_inventory), status: :ok
    else
      render json: {
          errors: rental.errors.messages
      }, status: :bad_request
      return
    end
  end

  def check_in
    rental = Rental.find_by(customer_id: params[:customer_id], video_id: params[:video_id])

    if rental.nil?
      render json: {
          "errors": [
              "Not Found"
          ]
      }, status: :not_found
      return
    end

    if rental.check_in_video
      render json: rental.as_json(only: [:customer_id, :video_id]).merge(
          videos_checked_out_count: rental.customer.videos_checked_out_count,
          available_inventory: rental.video.available_inventory), status: :ok
    else
      render json: {
          errors: rental.errors.messages
      }, status: :bad_request
      return
    end
  end
end
