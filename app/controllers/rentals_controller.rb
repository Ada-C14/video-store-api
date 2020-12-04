class RentalsController < ApplicationController
  def check_in
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil?
      render json: {
          errors: ["Not Found"]
      }, status: :not_found
      return
    elsif video.nil?
      render json: {
          errors: ["Not Found"]
      }, status: :not_found
      return
    end

    rental = Rental.new(rental_params)

    if rental.save
      rental.customer.update_checked_in
      rental.video.checkin_increase_inventory
      if rental.video.save && rental.customer.save
        render json: {
            "customer_id": rental.customer_id,
            "video_id": rental.video_id,
            "videos_checked_out_count": rental.customer.videos_checked_out_count,
            "available_inventory": rental.video.available_inventory
        }, status: :ok
      else
        render json: {
            ok: false,
            errors: rental.errors.messages
        }, status: :not_found
        return
      end
    end
  end

  def check_out
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil?
      render json: {
          errors: ["Not Found"]
      }, status: :not_found
      return
    elsif video.nil?
      render json: {
          errors: ["Not Found"]
      }, status: :not_found
      return
    end

    rental = Rental.new(rental_params)

    if rental.save
      rental.customer.update_checked_out
      rental.video.checkout_decrease_inventory
      if rental.video.save && rental.customer.save
        render json: {
            "customer_id": rental.customer_id,
            "video_id": rental.video_id,
            "due_date": rental.due_date,
            "videos_checked_out_count": rental.customer.videos_checked_out_count,
            "available_inventory": rental.video.available_inventory
        }, status: :ok
      else
        render json: {
            ok: false,
            errors: rental.errors.messages
        }, status: :not_found
        return
      end
    end
  end

  private
  def rental_params
    params.permit(:video_id, :customer_id)
  end
end
