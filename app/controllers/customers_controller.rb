class CustomersController < ApplicationController
  def index
    # Rails orders db by updated_at
    customers = Customer.all.order(:id).as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :videos_checked_out_count])
    render json: customers, status: :ok
  end
end
