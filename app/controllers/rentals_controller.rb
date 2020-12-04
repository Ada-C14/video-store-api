class RentalsController < ApplicationController

  def check_out_rental
    rental = Rental.new(rental_params)

    unless rental.valid_video? && rental.valid_customer?
      render json: {
        errors: ['Not Found']
      }, status: :not_found
      return
    end

    rental_video = Video.find_by(id: rental.video_id)

    unless rental_video.in_stock?
      render json: {
        status: 'error',
        code: 3000,
        message: 'Video does not have available stock'
      }
      return
    end

    if rental.save
      rental.initialize_rental

      render json: {
        customer_id: rental.customer_id,
        video_id: rental.video_id,
        due_date: rental.due_date,
        available_inventory: rental.video.available_inventory,
        videos_checked_out_count: rental.customer.videos_checked_out_count
      }, status: :ok

      return
    end

    render json: {
      errors: ['Not Found']
    }, status: :not_found

    return
  end

  def check_in_rental
    rental = Rental.where(
      video_id: params[:video_id],
      customer_id: params[:customer_id],
      checked_in: nil
    )

    if rental.nil?
      render json: { errors: ['Not Found'] }, status: :not_found
    elsif rental.customer_valid?.nil?
      render json: { errors: ['Customer Not Found'] }, status: :not_found
    elsif rental.video_valid?.nil?
      render json: { errors: ['Video Not Found'] }, status: :not_found
    else
      rental.rental_checkin

      render json: rental.as_json(
        only: [:customer_id, :video_id, :checked_in],
        include: {
          customer: { only: [:videos_checked_out_count] },
          video: { only: [:available_inventory] }
        }
      ), status: :ok

    end
    return
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
