class RentalsController < ApplicationController

  # def index
  #   rentals = Rental.all.as_json(only: [:customer_id, :video_id, :checkout_date, :due_date, :status])
  #   render json: rentals, status: :ok
  # end


  def check_out
    video = Video.find_by(id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])
    rental = Rental.new(customer: customer, video: video, checkout_date: Date.today, due_date: (Date.today + 7), status: "unavailable")

    if !video.nil? && video.available_inventory <= 0
      render json: {
          errors: ['Not Found']
      }, status: :not_found
      return
    elsif rental.save
      video.available_inventory -= 1
      video.save
      customer.videos_checked_out_count += 1
      customer.save

      render json: { customer_id: rental.customer_id,
                     video_id: rental.video_id,
                     due_date: rental.due_date,
                     videos_checked_out_count: customer.videos_checked_out_count,
                     available_inventory: video.available_inventory }
    else
      render json: {
          errors: ['Not Found']
      }, status: :not_found

      return
    end
  end

  def check_in
    rental = Rental.find_by(customer_id: params[:customer_id], video_id: params[:video_id])

    if rental.nil?
      render json: {
          errors: ["Not Found"],
      },status: :not_found
    elsif rental
      rental.customer.videos_checked_out_count -= 1
      rental.customer.save
      rental.video.available_inventory += 1
      rental.video.save
      rental.status = "available"
      rental.save

      render json: { customer_id: rental.customer_id,
                     video_id: rental.video_id,
                     videos_checked_out_count: rental.customer.videos_checked_out_count,
                     available_inventory: rental.video.available_inventory }, status: :ok
    end
  end
end

