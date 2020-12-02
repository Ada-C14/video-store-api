class CustomersController < ApplicationController
  def index
    customers = Customer.all
    render json: customers.as_json(
      only: %i[
        name
        registered_at
        address
        city
        state
        postal_code
        phone
        videos_checked_out_count
      ]
    ), status: :ok
  end
end
