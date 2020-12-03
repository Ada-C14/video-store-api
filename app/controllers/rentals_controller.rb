class RentalsController < ApplicationController

  def checkout
    customer = find_customer
    video = find_video

    rental = Rental.new(rental_params)
    rental.due_date = Date.today + 7
    if video && video.available_inventory < 1
      render json: {
          ok: false,
          errors: ["Insufficient inventory"]
      }, status: :bad_request
    else
      if rental.save
        rental.checkout_update
        render json: {
            customer_id: customer.id,
            video_id: video.id,
            due_date: rental.due_date,
            videos_checked_out_count: customer.videos_checked_out_count,
            available_inventory: video.available_inventory
        }, status: :ok
      elsif customer.nil? || video.nil?
        render json: {
            ok: false,
            errors: rental.errors.messages
        }, status: :not_found
      end
    end
  end

  def checkin
    video = find_video
    customer = find_customer
    rental = nil

    if customer && video
      rental = Rental.find_by(customer_id: customer.id, video_id: video.id)
    end


    if customer.nil?
      render json: {
          ok: false,
          errors: ["customer not found"]
      }, status: :not_found
    elsif video.nil?
      render json: {
          ok: false,
          errors: ["video not found"]
      }, status: :not_found
    elsif rental.nil?
      render json: {
          ok: false,
          errors: ["rental not found"]
      }, status: :not_found
    else
      rental.checkin_update
      rental.update(return_date: Date.today)

      render json: {
          customer_id: customer.id,
          video_id: video.id,
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
      }, status: :ok
    end
  end


  private
  def rental_params
    params.permit(:video_id, :customer_id)
  end

  def find_customer
    Customer.find_by(id: params[:customer_id])
  end

  def find_video
    Video.find_by(id: params[:video_id])
  end
end
