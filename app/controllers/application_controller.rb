class ApplicationController < ActionController::API
  def index
    render json: { ready_for_lunch: "it works!" }, status: :ok
  end
end
