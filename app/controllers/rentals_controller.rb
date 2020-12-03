class RentalsController < ApplicationController
  def check_out
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil?
      render json: { errors: ["Not Found"] },
             status: :not_found
      return  
    elsif video.nil?
      render json: { errors: ["Not Found"] },
             status: :not_found
      return
    end

    rental = Rental.new(rental_params)
    customer.checkout_update
    video.checkout_update
    rental.checkout_update

    if rental.save 
      response = {customer_id: rental.customer_id, 
                  video_id: rental.video_id, 
                  due_date: rental.due_date, 
                  videos_checked_out_count: customer.videos_checked_out_count,
                  available_inventory: video.available_inventory
                }

      render json: response.as_json, status: :ok

    # render json: rental.as_json(include: {customer: {only: [:videos_checked_out_count]}, video: {only: [:available_inventory]}}, only: [:customer_id, :video_id, :due_date]), status: :ok
    else
      render json: { errors: rental.errors.messages }, status: :bad_request
    end
  end

  private

  def rental_params
    return params.permit(:video_id, :customer_id)
  end
end
