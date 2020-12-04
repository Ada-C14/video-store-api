class CustomersController < ApplicationController
  def index
    customers = Customer.all.order(:name)
    render json: customers.as_json(only: [:id, :name, :registered_at, :postal_code,
                                     :phone, :videos_checked_out_count]), status: :ok
  end

  def show
    customer = Customer.find_by(id: params[:id])

    if customer.nil?
      render json: {
        ok: false,
        message: "Not found",
      }, status: :not_found

      return
    end

    render json: customer.as_json(only: [:id, :name, :registered_at, :postal_code,
                                         :phone, :videos_checked_out_count]),
           status: :ok
  end

  def create
    
  end

end
