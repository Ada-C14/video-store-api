class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])
    if video.nil?
      render json: {
        ok: false,
        message: "Not found"
      }, status: 404

    else
      render json: video.as_json(only: [:id, :title, :overview, :release_date, :total_inventory, :available_inventory]), status: :ok
    end
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: {
          ok: true,
          video: video.as_json(only: [:id])
      }, status: :created
      return
    else
      render json: {
          ok: false,
          errors: video.errors.messages
      }, status: :bad_request
    end
  end

  private

  def video_params
    return params.require(:video).permit(:title, :overview, :release_date,
                                         :total_inventory, :available_inventory)
  end
end
