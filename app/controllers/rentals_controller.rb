class RentalsController < ApplicationController
  def check_out
    rental = Rental.new(rental_params)
    rental.due_date = Date.today + 7.days

    if rental.video && rental.video.available_inventory < 1
      render json: {
        ok: false,
        errors: ["Not enough available inventory"]
      }, status: :bad_request
      return
    end
    
    if rental.save
      rental.customer.increment_checkout_count
      rental.video.decrement_inventory

      json_to_return = rental.as_json(only: [:customer_id, :video_id, :due_date])
      json_to_return[:videos_checked_out_count] = rental.customer.videos_checked_out_count
      json_to_return[:available_inventory] = rental.video.available_inventory

      render json: json_to_return, status: :ok
      return
    else
      render json: {
          ok: false,
          errors: rental.errors.messages
      }, status: :not_found
      return
    end
  end

  def check_in
    rental = Rental.where(customer_id: params[:customer_id], video_id: params[:video_id]).order(:created_at).filter { |rental| rental.created_at == rental.updated_at }.last

    if rental.nil?
      render json: {
        ok: false,
        errors: ["Invalid rental"]
      }, status: :not_found
      return
    else
      rental.updated_at = Time.now
      rental.customer.decrement_checkout_count
      rental.video.increment_inventory

      json_to_return = rental.as_json(only: [:id, :customer_id, :video_id])
      json_to_return[:videos_checked_out_count] = rental.customer.videos_checked_out_count
      json_to_return[:available_inventory] = rental.video.available_inventory

      render json: json_to_return, status: :ok
      return
    end
  end

  def overdue
    rentals = Rental.parameterized_list(params[:sort], params[:n], params[:p]).filter { |rental| rental.due_date && (rental.due_date < Date.today) }

    if rentals.nil? || rentals.empty?
      message = "There are no overdue rentals"
      render json: {
        ok: true,
        message: message,
        errors: [message]
      }, status: :ok
    else
      rentals_json = []

      rentals.each do |rental|
        rental_hash = Hash.new
        rental_hash[:video_id] = rental.video.id
        rental_hash[:title] = rental.video.title
        rental_hash[:customer_id] = rental.customer.id
        rental_hash[:name] = rental.customer.name
        rental_hash[:postal_code] = rental.customer.postal_code
        rental_hash[:checkout_date] = rental.created_at

        rentals_json << rental_hash
      end

      render json: rentals_json.as_json, status: :ok
    end

    return
  end

  private

  def rental_params
    params.permit(:customer_id, :video_id, :due_date)
  end


end
