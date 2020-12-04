class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      # had to comment the following line out in order for postman smoke test to pass
      # render json: { 'ok': false, 'errors': ['Not Found'] }, status: :not_found
      render json: { 'errors': ['Not Found'] }, status: :not_found
      return
    end

    render json: video.as_json(only: [:overview, :title, :release_date, :available_inventory, :total_inventory]),  status: :ok
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
      return
    else
      render json: { errors: video.errors.messages }, status: :bad_request
      # had to comment the following line out in order for postman smoke test to pass
      # render json: {
      #     ok: false,
      #     errors: video.errors.messages
      # }, status: :bad_request
      return
    end
  end

  private

  def video_params
    return params.permit(:id, :title, :release_date, :available_inventory, :overview,:total_inventory)
  end
end
