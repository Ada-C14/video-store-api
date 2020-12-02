class VideosController < ApplicationController
  def index
    videos = Video.all

    render json: videos.as_json(only: [:id, :title, :release_date, :available_inventory]),
           status: :ok
  end

  private

  def video_params
    return params.require(:video).permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end
end