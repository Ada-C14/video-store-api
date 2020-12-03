class VideosController < ApplicationController

  def index
    videos = Video.all.as_json(only: [:id, :title, :release_date, :available_inventory ] )
    render json: videos, status: :ok
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
    else
      render json: { errors: video.errors.messages }, status: :bad_request
    end
  end

  private

  def video_params
    params.permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end
end
