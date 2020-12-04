class RentalsController < ApplicationController

  def check_in
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

    rental = Rental.find_by(customer_id: customer.id, video_id: video.id)

    if rental.nil?
      render json: {
          errors: ['Not found'] },
             status: :not_found
      return
    else
    # rental.checkin_update
    customer.checkin_update
    video.checkin_update
    rental.save
    response = {customer_id: customer.id,
                video_id: video.id,
                videos_checked_out_count: customer.videos_checked_out_count,
                available_inventory: video.available_inventory
    }

    render json: response.as_json, status: :ok

    end

  end




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

    if video.checkout_update && customer.checkout_update && rental.checkout_update
      response = {
        customer_id: rental.customer_id, 
        video_id: rental.video_id, 
        due_date: rental.due_date, 
        videos_checked_out_count: customer.videos_checked_out_count,
        available_inventory: video.available_inventory
      }

      render json: response.as_json, status: :ok
    else
      error_msg = {
        rental: rental.errors.messages,
        video: video.errors.messages,
        customer: customer.errors.messages
      }
      render json: { errors: error_msg }, status: :bad_request
    end
  end

  private

  def rental_params
    return params.permit(:video_id, :customer_id)
  end
end
