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
      }, status: 200
    else
      render json: {
        # ok: false, # To make smoke test pass
        errors: rental.errors.messages
      }, status: 400
    end
  end

  def destroy
    rental = Rental.find_by(rental_params)

    if rental&.check_in
      customer = rental.customer
      video = rental.video
      if rental.destroy
        render json: {
          customer_id: customer.id,
          video_id: video.id,
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
        }, status: 200
      else
        render json: {
          errors: rental.errors.messages
        }, status: 400
      end
    else
      render json: {
        errors: "Not Found"
      }, status: 404
    end
    return
  end

  private

  def rental_params
    return params.permit(:customer_id, :video_id)
  end

  def find_customer
    customer = Customer.find_by(id: params[:customer_id])

    if customer.nil?
      render json: {
        # ok: false, # To make smoke test pass
        # message: ["Customer not found"]
        errors: ["Not Found"]
      }, status: 404
      return
    end

    return customer
  end

  def find_video
    video = Video.find_by(id: params[:video_id])

    if video.nil?
      render json: {
        # ok: false, # To make smoke test pass
        # message: ["Video not found"]
        errors: ["Not Found"]
      }, status: 404
      return
    end

    return video
  end

  def check_inventory
    unless find_video.available?
      render json: {
        # ok: false, # To make smoke test pass
        # message: ["Video is not available to check-out"]
        errors: ["Not Found"],
      }, status: 400

      return
    end
  end
end

