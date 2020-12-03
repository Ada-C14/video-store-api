class VideosController < ApplicationController
  def index
    videos = Video.all
    render json: videos.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]), status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      render json: {
          ok: false,
          message: 'not found',
      }, status: :not_found
      return
    end
    render json:video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]), status: :ok
  end

  def create
    video = Video.new(video_params)
    if video.save
      render json: video.as_json, status: :created
    else
      #
    end
  end
end

private
def video_params
  return params.require(:video).permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
end