class CustomersController < ApplicationController
  def index
    # customers = Customer.all
    render json: { ready_for_lunch: "yessss" }, status: :ok
  end

  def show
  end
end
