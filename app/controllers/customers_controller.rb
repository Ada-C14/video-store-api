class CustomersController < ApplicationController
  before_action :sort_column

  def index
    customers = Customer.all
    customers = customers.reorder(params[:sort] => :asc) if params[:sort]
    customers = customers.paginate(page: params[:p], per_page: params[:n]) if params[:p] || params[:n]

    render json: customers.as_json(only: [:id, :name, :registered_at, :postal_code, :phone, :videos_checked_out_count]),
            status: :ok
  end

  private
  
  def sort_column
    Customer.column_names.include?(params[:sort]) ? params[:sort] : (params[:sort] = "id")
  end
end
