class CustomersController < ApplicationController

  def index
    customers = Customer.all.as_json(only: [:id, :name, :phone, :postal_code, :registered_at, :videos_checked_out_count])
    render json: customers, status: :ok
  end

  def show

  end
end
