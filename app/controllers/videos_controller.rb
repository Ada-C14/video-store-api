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
          message: "Not Found",
          errors: "Not Found",
      }, status: :not_found
      return
    end

    render json: video.as_json(only: [:overview, :title, :release_date, :available_inventory, :total_inventory]),  status: :ok
  end
end
