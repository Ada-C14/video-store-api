class CustomersController < ApplicationController
  def index
    customers = Customer.all.order(:name)
    render json: customers, status: :ok
  end

end
