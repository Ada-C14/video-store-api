class ApplicationController < ActionController::API
  def zomg
    render json: { message: "it works!" }, status: :ok
  end
end
