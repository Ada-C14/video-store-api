class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id]).as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: video, status: :ok
  end
end
