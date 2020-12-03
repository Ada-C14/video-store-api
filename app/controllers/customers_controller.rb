class CustomersController < ApplicationController
  def index
    customers = Customer.all.order(:name)
    render json: customers.as_json(only: [:id, :name, :phone, :postal_code, :registered_at, :videos_checked_out_count]), status: :ok
  end

end
