class CustomersController < ApplicationController
  def index
    customers = Customer.all
    customers = customers.reorder(params[:sort] => :asc) if params[:sort]
    customers = customers.paginate(page: params[:p], per_page: params[:n]) if params[:p] || params[:n]

    render json: customers.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :videos_checked_out_count]),
            status: :ok
  end
end
