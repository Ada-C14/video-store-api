class RentalsController < ApplicationController

  def check_out
    video = Video.find_by_id(params[:video_id])
    rental = Rental.new(rental_params)
    if !video.nil? && video.available_inventory == 0
      render json: {
        errors: "No copies of #{rental.video.title} available"
      }, status: :bad_request
      return
    else
      if rental.save
        rental = Rental.find_by_id(rental.id)
        rental.video.decrement!(:available_inventory)
        rental.customer.increment!(:videos_checked_out_count)
        co_date = rental.created_at.to_date
        rental.update!(check_out: co_date, due_date: co_date + 7)
        rental_json = rental.as_json(only: [:customer_id, :video_id, :due_date])
        rental_json[:videos_checked_out_count] = rental.customer.videos_checked_out_count
        rental_json[:available_inventory] = rental.video.available_inventory
        render json: rental_json, status: :ok
      else
        render json: {
          errors: ['Not Found']
        }, status: :not_found
      end
    end
    return
  end

  def check_in
    customer = Customer.find_by(id: rental_params[:customer_id])
    video = Video.find_by(id: rental_params[:video_id])
    rental = Rental.find_by(video: video, customer: customer)
    p "RENTAL IS #{rental}"
    if customer.nil? || video.nil?
      render json: {
        errors: ['Not Found']
      }, status: :not_found
      return
    end

    if rental
      rental.check_in = Date.today
      rental.save
      rental.video.available_inventory += 1
      rental.video.save
      rental.customer.videos_checked_out_count -= 1
      rental.customer.save
      rental_json = rental.as_json(only: [:customer_id, :video_id])
      rental_json[:videos_checked_out_count] = rental.customer.videos_checked_out_count
      rental_json[:available_inventory] = rental.video.available_inventory
      render json: rental_json, status: :ok
    else
      render json: {
        errors: ['Not Found']
      }, status: :not_found
    end

    return
  end

  private

  def rental_params
    params.permit(:customer_id, :video_id)
  end
end

