class CustomersController < ApplicationController
  def index
    customers = Customer.all.order(:id).as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :videos_checked_out_count] )

    render json: customers, status: 200
  end
end
