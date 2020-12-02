class ApplicationController < ActionController::API

  def index
    render json: { testing: 'it works' }, status: :ok
  end
end
