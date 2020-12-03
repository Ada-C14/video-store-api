class RentalsController < ApplicationController

  def render_errors(errors, status)
    render json: {
        errors: errors
    }, status: status
  end

  def checkout

    errors = []

    unless params[:customer_id] && params[:video_id]
      errors << "ID Required"
      render_errors(errors, :bad_request)
      return
    end

    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])

    if customer.nil? || video.nil?
      errors << "Not Found"
      render_errors(errors, :not_found)
      return
    end
    
    if video.available_inventory <= 0
      errors << "Not In Stock"
      render_errors(errors, :bad_request)
      return
    end

    checkout_date = Date.today
    due_date = due_date
    rental = Rental.new(
        customer_id: customer.id,
        video_id: video.id,
        checkout_date: checkout_date,
        due_date: due_date)

    if rental.save
      customer.increment_rentals
      video.decrement_stock

      response = {
          customer_id: rental.customer_id,
          video_id: rental.video_id,
          due_date: rental.due_date,
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
      }

      render json: response.as_json, status: :ok
      return
    else
      render_errors(rental.errors.messages, :bad_request)
      return
    end
  end
  
  def checkin
    rental = Rental.find_by(video_id: params[:video_id], customer_id: params[:customer_id], return_date: nil)

    if rental.nil?
      render json: {
          errors: [
              "Not Found"
          ]
      }, status: :not_found
      return
    end

    if rental
      video = rental.video
      video.available_inventory += 1
      video.save
      available_inventory = rental.video.available_inventory

      customer = rental.customer
      if customer.videos_checked_out_count <= 0
        render json: {
            errors: rental.errors.messages
        }, status: :not_found
        return
      else
        customer.videos_checked_out_count -= 1
        customer.save
        videos_checked_out_count = rental.customer.videos_checked_out_count
      end

      rental.return_date = Date.today
      puts rental.return_date

      rental_view = rental.as_json(only: [:customer_id, :video_id])
      rental_view[:videos_checked_out_count] = videos_checked_out_count
      rental_view[:available_inventory] = available_inventory

      render json: rental_view,
             status: :ok
    else
      render json: {
          errors: rental.errors.messages
      }, status: :not_found
      return
    end
  end

  private

  def rental_params
    return params.permit(:customer_id, :video_id, :checkout_date, :due_date, :return_date)
  end
end
