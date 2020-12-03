class RentalsController < ApplicationController
  def checkout
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil?
      render json: {
          ok: false,
          error: "Customer Not Found"
      }, status: :not_found
      return
    elsif video.nil?
      render json: {
          ok: false,
          error: "Video Not Found"
      }, status: :not_found
      return
    end
    # error handling!
    # what if insufficient params?

    if video.available_inventory <= 0
      render json: {
          ok: false,
          error: "Not In Stock"
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
      customer.videos_checked_out_count += 1
      video.available_inventory -= 1

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
          ok: false,
          errors: rental.errors.messages
      }, status: :bad_request
    end
  end

  private

  def rental_params
    return params.require(:rental).permit(:customer_id, :video_id, :checkout_date, :due_date, :return_date)
  end
end
