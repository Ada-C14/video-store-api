class RentalsController < ApplicationController

  def overdue
    overdue_rentals = Rental.where('due_date < ?', Date.today)

    attribute = params["sort"]
    if attribute.nil?
      overdue_rentals.all.order(:id)
    else
      overdue_rentals.all.order(attribute)
    end

    #checkout_date
    #
    overdue_rentals.each do |rental|
      customer = Customer.find_by(id: rental.customer_id)
      video = Video.find_by(id: rental.video_id)


      render json: { customer_id: customer.id, video_id: video.id, title: video.title, name: customer.name, postal_code: customer.postal_code, due_date: rental.due_date },
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
        due_date: (Date.today + 7),
        customer_id: customer.id,
        video_id: video.id,
        videos_checked_out_count: customer.videos_checked_out_count + 1,
        available_inventory: video.available_inventory - 1
    )

    if rental.save
      # call method to increment customer videos checked out
      rental.videos_checked_out_count = customer.toggle_up_video_count
      # # call method to decrease available inventory
      rental.available_inventory = video.toggle_down_inventory
      rental.save

      render json: rental.as_json(only: [:customer_id, :video_id, :due_date, :videos_checked_out_count, :available_inventory]),
             status: :ok
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
    customer.save
    rental.assign_attributes(videos_checked_out_count: customer.videos_checked_out_count)

    video.toggle_up_inventory
    video.save
    rental.assign_attributes(available_inventory: video.available_inventory)
    rental.due_date = nil
    rental.save

    render json: rental.as_json(only: [:customer_id, :video_id, :videos_checked_out_count, :available_inventory]),
            status: :ok

  end
end
