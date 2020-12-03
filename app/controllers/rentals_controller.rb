class RentalsController < ApplicationController

  def check_out_rental
    rental = Rental.new(rental_params)

    unless rental.is_valid?
      render json: {
        status: 'error',
        code: 3000,
        message: 'Video does not have available stock'
      }
      return
    end

    if rental.save
      rental.initialize_rental

      render json: rental.as_json(
        only: [:customer_id, :video_id, :due_date],
        include: {
          customer: { only: [:videos_checked_out_count] },
          video: { only: [:available_inventory] }
        }
      ), status: :ok

      return
    end

    render json: {
      errors: ['Not Found']
    }, status: :not_found

    return
  end

  def check_in_rental
    rental = Rental.where(video_id: params[:video_id]).find_by(customer_id: params[:customer_id])

    if rental.nil?
      render json: { errors: "Not Found" }, status: :not_found
    else
      rental.rental_checkin
      render json: rental.as_json(only: [:customer_id, :video_id], include: {
          customer: { only: [:videos_checked_out_count] },
          video: { only: [:available_inventory] }
      }), status: :ok
    end
  end

  private

  def rental_params
    return params.permit(
      :id,
      :video_id,
      :customer_id,
      :due_date,
      :checked_out,
      :checked_in
    )
  end
end
