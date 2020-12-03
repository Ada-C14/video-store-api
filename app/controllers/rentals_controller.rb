class RentalsController < ApplicationController

  def index
    customers = Customer.all.as_json(only: [:customer_id, :video_id, :checkout_date, :due_date, :status])
    render json: customers, status: :ok
  end

end

