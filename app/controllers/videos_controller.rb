class VideosController < ApplicationController
  def index
    videos = Video.order(:title)
    render json: videos.as_json(only: [:id, :title, :release_date, :available_inventory]),
                                status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])
    if video.nil?
      render json: {
        ok: false,
        message: "No video found",
        errors: "Not Found"
      }, status: :not_found
      return
    end

      render json: video.as_json(only: [:title, :overview, :release_date, :available_inventory, :total_inventory]),
                                status: :ok
  end

  def create
  end
end
