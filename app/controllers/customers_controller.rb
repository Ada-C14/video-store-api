class CustomersController < ApplicationController
  before_action :find_customer, only: [:show, :currently_checked_out, :checkout_history]

  def index
    customers = Customer.parameterized_list(params[:sort], params[:n], params[:p])

    render json: customers.as_json(only: [:id, :name, :registered_at,:postal_code, :phone, :videos_checked_out_count]), status: :ok
  end

  def show
    render json: @customer.as_json(only: [:id, :name, :registered_at, :address, :city, :state, :phone, :postal_code, :videos_checked_out_count]), status: :ok
  end


  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer.as_json(only: [:id, :name, :registered_at, :address, :city, :state, :phone, :postal_code, :videos_checked_out_count]), status: :created
    else
      render json: {
          ok: false,
          errors: customer.errors.messages
      }, status: :bad_request
      return
    end
  end

  def currently_checked_out
    message = "#{@customer.name} does not currently have any checked out videos"
    videos = Video.parameterized_list(params[:sort], params[:n], params[:p]).filter { |video| video.rentals.any? {|rental| rental.customer == @customer && rental.created_at == rental.updated_at} }
    if videos.empty?
      render json: {
        ok: true,
        message: message,
        errors: [message]
      }, status: :ok
    else
      render json: videos.as_json(only: [:title, :checkout_date, :due_date]), status: :ok
    end
    return
  end

  def checkout_history
    message = "#{@customer.name} has not previously checked out any videos"
    videos = Video.parameterized_list(params[:sort], params[:n], params[:p]).filter { |video| video.rentals.any? {|rental| rental.customer == @customer && rental.created_at < rental.updated_at} }
    if videos.empty?
      render json: {
        ok: true,
        message: message,
        errors: [message]
      }, status: :ok
    else
      render json: videos.as_json(only: [:title, :checkout_date, :due_date]), status: :ok
    end
    return
  end

  private

  def customer_params
    params.permit(:name, :registered_at, :address, :city, :state, :postal_code, :phone, :videos_checked_out_count)
  end

  def find_customer
    @customer = Customer.find_by(id: params[:id])

    if @customer.nil?
      return render json: {ok: false, message: "Customer not found", errors: ['Not Found']}, status: :not_found
    end
  end
end
