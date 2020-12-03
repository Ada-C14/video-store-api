class RentalsController < ApplicationController
  def check_out



    customer = Customer.find_by(id: params[:id])
    video = Video.find_by(id: params[:id])

    customer.increase_checkedout_videos

    video.decrease_available_inventory

    rental = Rental.find_by(id: params[:id])

    due_date = rental.created_at.strftime("%F") + 1.week


    render json: rental.as_json(only: [:customer_id, :video_id, due_date, customer.videos_checked_out_count, video.available_inventory]),
           status: :ok

  end
end
