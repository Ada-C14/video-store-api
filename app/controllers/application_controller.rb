class ApplicationController < ActionController::API
  def test
    render json: { cat: "cute"}, status: :ok
  end
end
