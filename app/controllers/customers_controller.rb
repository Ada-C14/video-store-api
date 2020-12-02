class CustomersController < ApplicationController
  def index
    customers = Customer.all.order(:name)

    render json: customers.as_json(only: [:id, :name, :registered_at, :address, :city,
                                       :state, :postal_code, :phone]),
           status: :ok
  end
end
