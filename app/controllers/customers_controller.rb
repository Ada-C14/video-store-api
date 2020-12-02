class CustomersController < ApplicationController
  CUSTOMER_FIELDS = ["id", "name", "registered_at", "postal_code", "phone", "videos_checked_out_count"]

  def index
    customers = Customer.all.order(:name)
    render json: customers.as_json(only: CUSTOMER_FIELDS), status: :ok
  end
end
