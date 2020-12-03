class RentalsController < ApplicationController
  before_action :find_customer
  before_action :find_video

  def create
    rental = Rental.new(rental_params)

    check_inventory
    rental.check_out

    if rental.save
      render json: {
        customer_id: rental.customer_id,
        video_id: rental.video_id,
        due_date: rental.due_date,
        videos_checked_out_count: rental.customer.videos_checked_out_count,
        available_inventory: rental.video.available_inventory
      }, status: :created
    else
      render json: {
        ok: false,
        message: rental.errors.messages
      }, status: 400
    end
  end

  def destroy
  end

  private

  def rental_params
    return params.require(:rental).permit(:customer_id, :video_id)
  end

  def find_customer
    customer = Customer.find_by(id: params[:rental][:customer_id])

    if customer.nil?
      render json: {
        ok: false,
        message: "Customer not found"
      }, status: 404
    end

    return customer
  end

  def find_video
    video = Video.find_by(id: params[:rental][:video_id])

    if video.nil?
      render json: {
        ok: false,
        message: "Video not found"
      }, status: 404
    end

    return video
  end

  def check_inventory
    unless find_video.available?
      render json: {
        ok: false,
        message: "Video is not available to check-out"
      }, status: 400

      return
    end
  end
end

