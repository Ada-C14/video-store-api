class CustomersController < ApplicationController

  def index
    customers = Customer.all

    render json: customers.as_json(only: [:id, :name, :registered_at, :address, :city, :state, :phone, :postal_code, :videos_checked_out_count]), status: :ok
  end

  def show
    customer = Customer.find_by(id: params[:id])

    if customer.nil?
      return render json: {ok: false, message: "Customer not found"}, status: :not_found
    end

    render json: customer, status: :ok
  end


  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer, status: :created, location: customer
    else
      render json: customer.errors, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :registered_at, :address, :city, :state, :postal_code, :phone)
  end

end
