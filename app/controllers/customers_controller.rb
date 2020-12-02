class CustomersController < ApplicationController
  def index
    render json: "it works", status: :ok
  end
end
