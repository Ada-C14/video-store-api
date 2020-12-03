class RentalsController < ApplicationController

  def check_out_rental
    rental = Rental.new(rental_params)

    if rental.save && rental.is_valid?
      rental.initialize_rental
      render json: rental.as_json(only: [:id]), status: :created
      return
    end

    render json: {
      errors: rental.errors.messages
    }, status: :bad_request
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
