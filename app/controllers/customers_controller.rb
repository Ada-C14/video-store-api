class CustomersController < ApplicationController

  def index
    attribute = params["sort"]
    if attribute.nil?
      customers = Customer.all.order(:id)
    else
      customers = Customer.all.order(attribute)
    end

    render json: customers.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :videos_checked_out_count]), status: :ok
  end

end
