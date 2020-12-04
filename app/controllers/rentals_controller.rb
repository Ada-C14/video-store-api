class RentalsController < ApplicationController

  def overdue
    overdue_rentals = Rental.where('due_date < ?', Date.today)

    attribute = ["title", "name", "due_date"]
    if attribute.include?(params["sort"])
      overdue_rentals.all.order(params["sort"])
    else
      overdue_rentals.all.order(:id)
    end

    #checkout_date

    overdue_rentals.each do |rental|
      customer = Customer.find_by(id: rental.customer_id)
      video = Video.find_by(id: rental.video_id)


      render json: { customer_id: customer.id, video_id: video.id, title: video.title, name: customer.name, postal_code: customer.postal_code, due_date: rental.due_date, checkout_date: rental.checkout_date },
             status: :ok
    end

  end

  def checkout
    video = Video.find_by(id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])

    if video.nil? || customer.nil?
      render json: { errors: ["Not Found"] }, status: :not_found
      return
    end

    rental = Rental.new(
        due_date: Date.today + 7,
        customer_id: customer.id,
        video_id: video.id,
        checkout_date: Date.today
    )

    if rental.save
      # call method to increment customer videos checked out
      customer.toggle_up_video_count
      # call method to decrease available inventory
      video.toggle_down_inventory

      render json: rental.as_json(only: [:customer_id, :video_id, :due_date]).merge(
          videos_checked_out_count: customer.videos_checked_out_count,
          available_inventory: video.available_inventory
      ), status: :ok
    else
      render json: { errors: rental.errors.messages }, status: :not_found
    end

  end

  def check_in
    video = Video.find_by(id: params[:video_id])
    customer = Customer.find_by(id: params[:customer_id])

    if video.nil? || customer.nil?
      render json: { errors: ["Not Found"] }, status: :not_found
      return
    end

    rental = Rental.find_by(video_id: video.id, customer_id: customer.id)

    if rental.nil?
      render json: { errors: ["Not Found"] }, status: :not_found
      return
    end

    customer.toggle_down_video_count
    video.toggle_up_inventory
    rental.due_date = nil
    rental.save

    render json: rental.as_json(only: [:customer_id, :video_id]).merge(
        videos_checked_out_count: rental.customer.videos_checked_out_count,
        available_inventory: rental.video.available_inventory
    ), status: :ok

  end
end
