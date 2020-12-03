class VideosController < ApplicationController
  def index
    videos = Videos.all.as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end
end
