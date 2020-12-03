class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])
    if video
      render json: video.as_json(only: [:title, :overview, :release_date, :available_inventory, :total_inventory]), status: :ok
    else
      render json: {ok: false, errors: ["Not Found"]}, status: :not_found
    end
  end

  private
  def video_params
    return params.require(:video).permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end
end
