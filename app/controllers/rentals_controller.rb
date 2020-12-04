class RentalsController < ApplicationController
  def index
    rentals = Rental.all.order(:id)

    render json: rentals.as_json(only: [:id, :customer_id, :video_id, :due_date, :videos_checked_out_count,
                                        :available_inventory]), status: :ok
  end

  def show
  end

  def check_out
    new_rental = Rental.new(rental_params)
    new_rental.check_out_date = Date.today
    new_rental.due_date = Date.today + 7.days
    new_rental.returned = false

    customer = Customer.find_by(id: new_rental.customer_id)
    video = Video.find_by(id: new_rental.video_id)
    video.available_inventory_update(-1)
    customer.checked_out_count(1)
    if new_rental.save
      render json: new_rental.as_json(only: [:customer_id, :video_id, :due_date]).merge(available_inventory: video.available_inventory,
                                      videos_checked_out_count: customer.videos_checked_out_count), status: :ok

      # render json: { message: "Rental ID #{new_rental.id}: #{new_rental.video[:title]} due on #{new_rental.due_date}"}, status: :ok
      return
    else
      render json: {
          errors: new_rental.errors.messages
          }, status: :bad_request
          return
    end
  end


  # def create
  #   rental = Rental.new(rental_params)
  #   if rental.save
  #     render json: rental.as_json(only: [:id]), status: :created
  #   else
  #     render json: {
  #         errors: rental.errors.messages
  #     }, status: :bad_request
  #     return
  #   end
  # end



  def rental_params
    return params.permit(:id, :customer_id, :video_id, :due_date, :videos_checked_out_count,
                         :available_inventory)
  end
end
