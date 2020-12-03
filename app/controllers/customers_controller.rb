class CustomersController < ApplicationController

  def index
    customers = Customer.parameterized_list(params[:sort], params[:n], params[:p])

    render json: customers.as_json(only: [:id, :name, :registered_at,:postal_code, :phone, :videos_checked_out_count]), status: :ok
  end

  def show
    customer = Customer.find_by(id: params[:id])

    if customer.nil?
      return render json: {ok: false, message: "Customer not found", errors: ['Not Found']}, status: :not_found
    end

    render json: customer.as_json(only: [:id, :name, :registered_at, :address, :city, :state, :phone, :postal_code, :videos_checked_out_count]), status: :ok
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

  private

  def customer_params
    params.permit(:name, :registered_at, :address, :city, :state, :postal_code, :phone, :videos_checked_out_count)
  end

end
