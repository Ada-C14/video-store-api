class CustomersController < ApplicationController
  def index
    customers = Customer.all.order(:id)
    render json: customers.as_json(except: [:address, :city, :state, :created_at, :updated_at]), status: :ok

  end

  def show
    customer = Customer.find_by(id: params[:id])
    if customer.nil?
      render json: {
        ok: false,
        message: 'Not Found'
      }, status: :not_found
      return
    end
    render json: customer.as_json(except: [:created_at, :updated_at]), status: :ok
  end
end
