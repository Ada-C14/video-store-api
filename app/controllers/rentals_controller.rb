class RentalsController < ApplicationController

  before_action :find_customer
  before_action :find_video

  def check_out
    rental = Rental.new(video: @video, customer: @customer ,due_date: Time.now + 7.days )

    if !@video.nil? && @video.available_inventory == 0
      render json: {
          errors: "No available copies for this title"
      }, status: :bad_request
      return
    end

    if rental.save
      # rental.decrease_available_inventory
      # rental.increase_videos_checked_out

      rental.video.decrement!(:available_inventory)
      rental.customer.increment!(:videos_checked_out_count)

      render json: {
          customer_id: @customer.id,
          video_id: @video.id,
          due_date: rental.due_date,
          videos_checked_out_count: @customer.videos_checked_out_count,
          available_inventory: @video.available_inventory
      }, status: :ok
      return
    else
      render json: { errors: ['Not Found'] }, status: :not_found
      return
    end

  end

  def check_in

    rental = Rental.where(video: @video, customer: @customer)
  end

  private

  def find_customer
    @customer = Customer.find_by(id: params[:customer_id])
  end

  def find_video
    @video = Video.find_by(id: params[:video_id])
  end
end
