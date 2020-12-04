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
      customer_id: params[:customer_id].to_i,
      checked_in: nil
    ).find_by(video_id: params[:video_id].to_i)

    if rental.nil?
      render json: { errors: ['Not Found'] }, status: :not_found
    end

    unless rental.valid_video? && rental.valid_customer?
      render json: {
        errors: ['Not Found']
      }, status: :not_found
      return
    end

    rental.rental_checkin

    render json: {
      customer_id: rental.customer_id,
      video_id: rental.video_id,
      due_date: rental.due_date,
      available_inventory: rental.video.available_inventory,
      videos_checked_out_count: rental.customer.videos_checked_out_count
    }, status: :ok

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
