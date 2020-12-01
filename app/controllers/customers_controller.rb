class CustomersController < ApplicationController
  def index
    customers = Customer.all.order(:name)

    render json: customers.as_json(only: [:id, :name, :registered_at, :address, :city, :state, :postal_code, :phone]),
           status: :ok
  end

  def show
    customer = Customer.find_by(id: params[:id])

    if customer.nil?
      render json: {
          ok: false,
          message: 'Not found',
      }, status: :not_found

      return
    end

    render json: customer.as_json(only: [:id, :name, :registered_at, :address, :city, :state, :postal_code, :phone]),
           status: :ok
  end

  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer.as_json(only: [:id]), status: :created
    else
      render json: { errors: customer.errors.messages }, status: :bad_request
    end
  end

  private

  def customer_params
    return params.require(:customer).permit(:name, :registered_at, :address, :city, :state, :postal_code, :phone)
  end
end
