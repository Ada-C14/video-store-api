class VideosController < ApplicationController

  def index
    videos = Video.all.as_json(only: [:id, :title, :phone, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show

  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
      return
    else
      render json: {
          ok: false,
          errors: video.errors.messages
      }, status: :bad_request
      return
    end
  end

  private

  def video_params
    return params.require(:video).permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end

end
