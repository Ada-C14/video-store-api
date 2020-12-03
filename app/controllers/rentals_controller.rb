class RentalsController < ApplicationController

  def check_out
    rental = Rental.new(customer_id: params[:customer_id], video_id: params[:video_id], due_date: Date.today + 7)
    if rental.save

      rental.customer.videos_checked_out_count += 1
      rental.customer.save!

      rental.video.available_inventory -= 1
      if rental.video.save
        return render json: rental.as_json(only: [:customer_id, :video_id, :due_date]).merge(
          videos_checked_out_count: rental.customer.videos_checked_out_count,
          available_inventory: rental.video.available_inventory
        )
      else
        return render json: { errors: rental.video.errors.messages }, status: :bad_request
      end

    else
      return render json: { errors: ["Not Found"] }, status: :not_found
    end
  end
end
