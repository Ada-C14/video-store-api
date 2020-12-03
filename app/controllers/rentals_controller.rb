class RentalsController < ApplicationController
  def check_out
    rental = Rental.new(video: @video, customer: @customer ,due_date: Time.now + 7.days )

    if rental.save
      # do something
      rental.decrease_available_inventory
      rental.increase_videos_checked_out

      render json: rental.as_json(only: [:id, :due_date]), status: :created
      return
    else # doesn't save, surface error messages
      render json: {ok: false, errors: rental.errors.messages}, status: :bad_request
      return
    end

  end

  def check_in

  end

  private

  def find_customer
    @customer = Customer.find_by(id: params[:id])
  end

  def find_video
    @video = Video.find_by(id: params[:id])
  end


end
