class RentalsController < ApplicationController
  def check_in
    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])
    if video.nil? || customer.nil?
      render json: {
          errors: ['Not Found'],
      }, status: :not_found
      return
    end
    rental = Rental.find_by(customer_id: customer.id, video_id: video.id)
    if rental.nil?
      render json: {
          ok: false,
          message: 'Not found',
      }, status: :not_found
      return
    end
    video.increase_available_inventory
    customer.decrease_video_checked_out_count
    render json: rental.as_json(only: [:customer_id, :video_id]).merge({videos_checked_out_count: customer.videos_checked_out_count, available_inventory: video.available_inventory}),
             status: :ok
  end

  def check_out
    video = Video.find_by(id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])

    if video.nil? || customer.nil?
      render json: {
          errors: ['Not Found'],
      }, status: :not_found
      return
    end

    rental = Rental.new(customer_id: customer.id, video_id: video.id, due_date: Date.today + 1.week)
    if rental.save
      video.decrease_available_inventory
      customer.increase_video_checked_out_count

      render json: {
          customer_id: customer.id,
          video_id: video.id,
          due_date: Date.today + 1.week,
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
      }, status: :created
      return
    else
      render json: { errors: rental.errors.messages }, status: :bad_request
      return
    end
  end

  private

  def rental_params
    return params.permit(:video_id, :customer_id)
  end
end
