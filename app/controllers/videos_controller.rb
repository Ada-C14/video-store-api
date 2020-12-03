class VideosController < ApplicationController
  def index
    videos = Video.all
    render json: videos.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]), status: :ok
  end

  def show
  end

  def create
  end
end

private
def video_params
  return params.require(:video).permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
end