class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])
    if video.nil?
      render json: {
        ok: false,
        message: "Not found"
      }, status: 404

    else
      render json: video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]), status: :ok
    end
  end

  def create
  end
end
