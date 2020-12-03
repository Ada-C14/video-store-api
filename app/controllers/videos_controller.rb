class VideosController < ApplicationController
  def index
    videos = Video.all
    videos = Video.all.as_json(only: [:id, :title, :overview, :release_date, :total_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video
      render json: video.as_json(only: [:id, :title, :overview, :release_date, :total_inventory])
    else
      not_found
    end
  end
end

def create
  video = Video.new(video_params)

  if video.save
    render json: video.as_json(only: [:id]), status: :ok
    return
  else
    bad_request(video)
  end
end

private

def video_params
  params.require(:video).permit(:title, :overview, :release_date, :total_inventory)
end