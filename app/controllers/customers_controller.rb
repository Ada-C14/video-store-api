class CustomersController < ApplicationController
  def index
    customers = Customer.all.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :videos_checked_out_count])
    render json: customers, status: :ok
  end

  def show
    customer = Customer.find_by(id: params[:id])

    if customer.nil?
      render json: {
          ok: false,
          errors: "Not Found",
          status: :ok
      }
      return
    end

    render json: customer.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :videos_checked_out_count]),
           status: :ok
  end
end
