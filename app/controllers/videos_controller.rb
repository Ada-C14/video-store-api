class VideosController < ApplicationController

  def index
    videos = Video.all.to_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])
    if video
      video = video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory])
      render json: video, status: :ok
    else
      render json: {ok: false, errors: "Not Found"}
    end
  end

end
