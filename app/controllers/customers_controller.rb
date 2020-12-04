class CustomersController < ApplicationController

  def index
    attribute = ["name", "postal_code", "registered_at"]
    if attribute.include?(params["sort"])
      customers = Customer.all.order(params["sort"])
    else
      customers = Customer.all.order(:id)
    end

    render json: customers.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :videos_checked_out_count]), status: :ok
  end

end
