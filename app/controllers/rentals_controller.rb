class RentalsController < ApplicationController

  def check_out
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil? || video.nil?
      render json: {
        errors: [
          'Not Found'
        ]
      }, status: :not_found
      return
    end

    rental = Rental.new(customer_id: customer.id, video_id: video.id)
    result = rental.save

    if result
      render json: {
        customer_id: rental.customer_id,
        video_id: rental.video_id,
        due_date: rental.due,
        videos_checked_out_count: customer.checkout,
        available_inventory: video.checkout
      }, status: :ok
    else
      render json: {
        errors: rental.errors.messages
      }, status: :bad_request
      return
    end

  end

  def check_in
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil? || video.nil?
      render json: {
        errors: [
          'Not Found'
        ]
      }, status: :not_found
      return
    else

      render json: {
        customer_id: customer.id,
        video_id: video.id,
        videos_checked_out_count: customer.checkin,
        available_inventory: video.checkin
      }, status: :ok
      return
    end

  end

  private
  def rental_params
    params.permit(:customer_id, :movie_id, :due_date)
  end
end
