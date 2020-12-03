class RentalsController < ApplicationController

  def check_out
    rental = Rental.new(customer_id: params[:customer_id], video_id: params[:video_id], due_date: Date.today + 7)
    if rental.save
      # rental.customer.videos_checked_out_count += 1
      rental.customer.save!

      rental.video.available_inventory -= 1
      # rental[:checked_out] = true

      if rental.video.save
        return render json: rental.as_json(only: [:customer_id, :video_id, :due_date]).merge(
            videos_checked_out_count: rental.customer.videos_checked_out_count,
            available_inventory: rental.video.available_inventory
        )
      else
        return render json: {errors: rental.video.errors.messages}, status: :bad_request
      end

    else
      return render json: {errors: ["Not Found"]}, status: :not_found

    end
  end

  def check_in
    rental = Rental.find_by(video_id: params[:video_id], customer_id: params[:customer_id])
    if rental.save
      rental.customer.videos_checked_out_count -= 1
      rental.customer.save!

      rental.video.available_inventory += 1
      rental[:checked_out] = false

      if rental.video.save
        return render json: rental.as_json(only: [:customer_id, :video_id, :due_date]).merge(
            videos_checked_out_count: rental.customer.videos_checked_out_count,
            available_inventory: rental.video.available_inventory
        )
      else
        return render json: {errors: rental.video.errors.messages}, status: :bad_request
      end

    else
      return render json: {errors: ["Not Found"]}, status: :not_found

    end

    # if (rental = Rental.find_by(video_id: params[:video_id], customer_id: params[:customer_id], checked_out: true))
    #   rental[:checked_out] = false
    #   rental[:due_date] = nil
    #   rental[:checkin_date] = Date.today
    #   rental.video.available_inventory += 1
    #   rental.save
    #   if rental.save
    #     return render json: rental.as_json(only: [:customer_id, :video_id, :videos_checked_out_count, :checkin_date]).merge(
    #         available_inventory: rental.video.available_inventory)
    #   else
    #     return render json: {errors: rental.video.errors.messages}, status: :bad_request
    #   end
    #
    # else
    #   return render json: {errors: ["Not Found"]}, status: :not_found
    #
    # end
    # rental = Rental.find_by(rental_params)
    # if rental
    #   rental.customer.videos_checked_out_count -= 1
    #   rental.video.available_inventory += 1
    # else
    #   return render json: {errors: rental.video.errors.messages}, status: :bad_request
    # end


  end


  private

  def rental_params
    params.permit(:customer_id, :video_id)
  end

end 
