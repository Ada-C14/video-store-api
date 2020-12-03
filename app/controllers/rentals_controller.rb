class RentalsController < ApplicationController
  def check_out

    customer = Customer.find_by(id: params[:customer_id])
    video = Video.find_by(id: params[:video_id])
    # if customer.nil?
    # elsif video.nil?
    # end


    rental = Rental.new(customer_id: customer.id, video_id: video.id, due_date: Date.today + 1.week)
    if rental.save
      customer.increase_checkedout_videos
      video.decrease_available_inventory
      render json: rental.as_json(only: [:customer_id, :video_id, :due_date, customer.videos_checked_out_count, video.available_inventory]),
             status: :ok
    else
      render json: {
          #    ok: false,
          errors: rental.errors.messages
      }, status: :bad_request
      return
    end



    # due_date = rental.created_at.strftime("%F") + 1.week




  end
end
