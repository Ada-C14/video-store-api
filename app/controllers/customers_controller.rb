class CustomersController < ApplicationController
  def index
    customers = Customer.all.as_json(only: [:id, :name, :phone, :registered_at, :postal_code, :videos_checked_out_count])
    render json: customers, status: :ok
  end
end
