class RentalsController < ApplicationController
  def check_in
    rental = Rental.find_by(id: params[:id])
    if rental.nil?
      render json: {
          ok: false,
          message: 'Not found',
      }, status: :not_found
    end
    rental.video_id.increase_available_inventory
    rental.customer_id.decrease_video_checked_out_count
    render json: rental.as_json(only: [:customer_id, :video_id, :due_date, :videos_checked_out_count, :available_inventory]),
             status: :ok
    # video = Video.find_by(rental_params)
    # customer = Customer.find_by(rental_params)
    #
    # if video.nil? || customer.nil?
    #   render json: {
    #       ok: false,
    #       message: 'Not found',
    #   }, status: :not_found
    # else
    #   due_date = Date.now + 1.week
    #   rental = Rental.new(customer_id: customer.id, video_id: video.id, due_date: due_date)
    #
    #   if rental.save
    #     video.increase_available_inventory
    #     customer.decrease_video_checked_out_count
    #
    #     render json: rental.as_json(only: [:id]), status: :created
    #   else
    #     render json: { errors: rental.errors.messages }, status: :bad_request
    #   end
    # end
    #
    # render json: rental.as_json(only: [:customer_id, :video_id, :due_date, :videos_checked_out_count, :available_inventory]),
    #        status: :ok
  end

  def check_out
    video = Video.find_by(rental_params)
    customer = Customer.find_by(rental_params)
    if video.nil? || customer.nil?
        render json: {
            ok: false,
            message: 'Not found',
        }, status: :not_found
    end
    due_date = Date.new + 1.week
    rental = Rental.new(customer_id: customer.id, video_id: video.id, due_date: due_date)
    if rental.save
      video.decrease_available_inventory
      customer.increase_video_checked_out_count

      render json: rental.as_json(only: [:id]), status: :created
    else
      render json: { errors: rental.errors.messages }, status: :bad_request
    end
    render json: rental.as_json(only: [:customer_id, :video_id, :due_date, :videos_checked_out_count, :available_inventory]),
           status: :ok
  end

  private

  def rental_params
    return params.require(:rental).permit(:video_id, :customer_id)
  end
end
