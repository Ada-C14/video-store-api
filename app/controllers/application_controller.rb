class ApplicationController < ActionController::API
  def render_date(date)
    date.strftime('%Y-%m-%d')
  end
end
