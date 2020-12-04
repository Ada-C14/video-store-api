class RentalsController < ApplicationController

  def check_out
    rental = Rental.new(customer_id: params[:customer_id], video_id: params[:video_id], due_date: Date.today + 7)
    if rental.invalid?
      return render json: {errors: ["Not Found"]}, status: :not_found
    end

      if rental.checkout
        return render json: rental.as_json(only: [:customer_id, :video_id, :due_date]).merge(

            videos_checked_out_count: rental.customer.videos_checked_out_count,
            available_inventory: rental.video.available_inventory
        ), status: :ok
      else
        rental.destroy # i want to destroy the rental created because video is invalid
        return render json: {errors: rental.video.errors.messages}, status: :bad_request

      end



  end

  def check_in
    rental = Rental.find_by(video_id: params[:video_id], customer_id: params[:customer_id])
    if rental.nil?
      return render json: {errors: ["Not Found"]}, status: :not_found
    end

    if rental.checkin

      return render json: rental.as_json(only: [:customer_id, :video_id]).merge(
          videos_checked_out_count: rental.customer.videos_checked_out_count,
          available_inventory: rental.video.available_inventory
      )
    else
      return render json: {errors: rental.video.errors.messages}, status: :bad_request
    end

  end


  private

  def rental_params
    params.permit(:customer_id, :video_id)
  end


end
