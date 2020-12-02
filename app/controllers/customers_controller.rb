class CustomersController < ApplicationController
  def index
    customers = Customer.all.as_json(only: [:id, :name, :address, :city, :state, :phone, :registered_at, :postal_code])
    render json: customers, status: :ok
  end

  def show
  end
end
