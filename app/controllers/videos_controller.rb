class VideosController < ApplicationController
  def index
    @videos = Video.all
    videos = Video.all.as_json(only: [:id, :title, :overview, :release_date, :total_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video
      render json: video.as_json(only: [:id, :title, :overview, :release_date, :available_inventory]), status: :created
      return
    else
      render json: {
          errors: video.errors
      }, status: :bad_request
      return
    end
  end


  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
      return
   else
     render json: {
          errors: video.errors
      }, status: :bad_request
      return
    end
  end

  private

  def video_params
    params.permit(:title, :overview, :release_date, :available_inventory, :total_inventory)
  end
end
