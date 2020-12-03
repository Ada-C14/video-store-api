class ApplicationController < ActionController::API
  def not_found
    render json: {
        ok: false,
        errors: ["Not Found"]
    }, status: :not_found
  end

  def bad_request(model)
    render json: {
        ok: false,
        errors: model.errors.messages
    }, status: :bad_request
  end
end
