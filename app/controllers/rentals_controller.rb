class RentalsController < ApplicationController
  def checkout

    errors = []

    unless params[:customer_id] && params[:video_id]
      errors << "ID Required"
      render json: {
          errors: errors
      }, status: :bad_request
      return
    end

    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil? || video.nil?
      errors << "Not Found"
      render json: {
          errors: errors
      }, status: :not_found
      return
    end

    if video.available_inventory <= 0
      errors << "Not In Stock"
      render json: {
          errors: errors
      }, status: :bad_request
      return
    end

    checkout_date = Date.today
    due_date = due_date
    rental = Rental.new(
        customer_id: customer.id,
        video_id: video.id,
        checkout_date: checkout_date,
        due_date: due_date)

    if rental.save
      customer.increment_rentals
      video.decrement_stock

      response = {
          customer_id: rental.customer_id,
          video_id: rental.video_id,
          due_date: rental.due_date,
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
      }

      render json: response.as_json, status: :ok
      return
    else
      render json: {
          errors: rental.errors.messages
      }, status: :bad_request
    end
  end

  private

  def rental_params
    return params.require(:rental).permit(:customer_id, :video_id, :checkout_date, :due_date, :return_date)
  end
end
