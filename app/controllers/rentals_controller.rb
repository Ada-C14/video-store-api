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
      # customer = Customer.find_by(id: rental.customer_id)
      # video = Video.find_by(id: rental.video_id)
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
    if params[:video_id]
      video = Video.find_by(id: params[:video_id])
      rental =  rental.video
    elsif params[:customer_id]
      customer = Customer.find_by(id: params[:customer_id])
      rental = rental.customer
    else
      rental = Rental.find_by(id: params[:id])
    end

    if rental.customer.nil?
      render json: { errors: rental.errors.messages }, status: :not_found
    elsif rental.video.nil?
      render json: { errors: rental.errors.messages }, status: :not_found
    else
      rental.customer.check_in && rental.video.check_in
      render json: rental.as_json(only: [:customer_id, :video_id, :videos_checked_out_count, :available_inventory]), status: :ok
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
