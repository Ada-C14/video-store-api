class VideosController < ApplicationController

  def index
    videos = Video.all

    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      return render json: {ok: false, message: "Video not found"}, status: :not_found
    end

    render json: video, status: :ok
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video, status: :created, location: video
    else
      render json: video.errors, status: :unprocessable_entity
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end
end
