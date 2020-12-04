class RentalsController < ApplicationController

  #check_out method
  # finding customer by id
  # find video by
  # creating a time stamp
  #
  # if there is no customer - return error message and bad request
  # if there is no video - return error message and bad request
  #  create a rental with customer_id, video_id, due_date
  # render json

  # def create
  #   rental = Rental.new(customer_id: customer.id, video_id: video.id, due_date: date)
  #   #if rental.available_inventory != 0
  #
  #   if rental.available_inventory != 0 && rental.save
  #     render json: rental.as_json(only: [:customer_id, :video_id, :due_date, :videos_checked_out_count, :available_inventory]), status: :ok
  #     return
  #   elsif rental.available_inventory == 0
  #     render json: {errors: ["Bad Request"]}, status: :bad_request
  #   else
  #     render json: {errors: ["Bad Request"]}, status: :bad_request
  #     return
  #   end
  #   return rental
  # end

  def check_out
    customer = find_customer
    video = find_video
    date = render_date(DateTime.now + 1.week)

    if find_customer.nil?
      render json: {errors: ["Not Found"]}, status: :not_found
      return
    end

    if find_video.nil?
      render json: {errors: ["Not Found"]}, status: :not_found
      return
    end

    rental = Rental.new(customer_id: customer.id, video_id: video.id, due_date: date)

    if rental.check_out(customer, video)
      rental.save
      render json: rental.as_json(only: [:customer_id, :video_id, :due_date], methods: [:videos_checked_out_count, :available_inventory]), status: :ok
      return
    elsif rental.available_inventory == 0
      render json: {errors: ["Bad Request"]}, status: :bad_request
    else
      render json: {errors: ["Bad Request"]}, status: :bad_request
      return
    end
  end

  def check_in
    customer = find_customer
    video = find_video

    if find_customer.nil?
      render json: {errors: ["Not Found"]}, status: :not_found
      return
    end

    if find_video.nil?
      render json: {errors: ["Not Found"]}, status: :not_found
      return
    end
    rental = Rental.find_by(customer_id: customer.id, video_id: video.id)
    if rental.nil?
      render json: {errors: ["Not Found"]}, status: :not_found
      return
    elsif rental
      if rental.check_in(customer, video)
        rental.save
        render json: rental.as_json(only: [:customer_id, :video_id, :due_date], methods: [:videos_checked_out_count, :available_inventory]), status: :ok
        return
      else
        render json: {errors: ["Bad Request"]}, status: :bad_request
        return
      end
    end
  end



  private

  def find_customer
    return Customer.find_by(id: params[:customer_id])
  end

  def find_video
    return Video.find_by(id: params[:video_id])
  end
end

#
# render json: rental.as_json(only: [:customer_id, :video_id, :due_date], include: {videos_checked_out_count: customer.videos_checked_out_count, available_inventory: video.available_inventory}), status: :ok