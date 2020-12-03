class VideosController < ApplicationController
  def index
    videos = Video.all.order(:id).as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])
    if video.nil?
      render json: {
        # ok: false, # To make smoke test pass
        errors: ["Not Found"]
      }, status: :not_found

    else
      render json: video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]), status: :ok
    end
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: {
          # ok: true, # To make smoke test pass
          id: video.id
      }, status: :created
      return
    else
      render json: {
          # ok: false, # To make smoke test pass
          errors: video.errors.messages
      }, status: :bad_request
    end
  end

  private

  def video_params
    return params.permit(:title, :overview, :release_date,
                                         :total_inventory, :available_inventory)
  end
end
