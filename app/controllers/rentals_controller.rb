class RentalsController < ApplicationController

  def checkout
    existing_customer = Customer.find_by(id: params[:customer_id])
    existing_video = Video.find_by(id: params[:video_id])

    if existing_customer.nil? || existing_video.nil?
      render json: {
          errors: ['Not Found']
      }, status: :not_found
      return
    elsif existing_video.available_inventory <= 0
      render json: {
          errors: ['Bad Request']
      }, status: :bad_request
      return
    end

    rental = Rental.new(rental_params)

    # create a new rental
    if rental.save

      rental.increase_customer_video_count
      rental.decrease_available_video_inventory
      rental.return_date

      customer = Customer.find_by(id: existing_customer.id)
      video = Video.find_by(id: existing_video.id)

      render json: {
          customer_id: rental.customer_id,
          video_id: rental.video_id,
          due_date: rental.due_date,
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
      }, status: :ok
      return
    end
  end

  def checkin
    #check rental exists (customer_id /video_id) combo
    # customer_id: params[:customer_id], video_id: params[:video_id]
    return_rental = Rental.find_by(rental_params)


    if return_rental
      # rid of the customer video count by 1
      return_rental.decrease_customer_video_count
      # increase available_inventory by 1
      return_rental.increase_available_video_inventory

      returning_customer = Customer.find_by(id: params[:customer_id])
      returning_video = Video.find_by(id: params[:video_id])

      render json: {
          customer_id: return_rental.customer_id,
          video_id: return_rental.video_id,
          videos_checked_out_count: returning_customer.videos_checked_out_count,
          available_inventory: returning_video.available_inventory
      }, status: :ok
      return
    else
      render json: {
          errors: ['Not Found']
      }, status: :not_found
      return
    end
  end

  private

  def rental_params
    return params.permit(:customer_id, :video_id)
  end

end
