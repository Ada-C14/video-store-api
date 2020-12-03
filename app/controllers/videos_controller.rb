class VideosController < ApplicationController
  def index
    videos = Video.all
    render json: videos.as_json(
      only: %i[
        id
        title
        release_date
        available_inventory
      ]
    ), status: :ok
    return
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      render json: {
        errors: ['Not Found'],
      }, status: :not_found
      return
    end

    render json: video.as_json(
      only: %i[
      title
      overview
      release_date
      total_inventory
      available_inventory
      ]
    ), status: :ok
    return
  end

  def create
    video = Video.new(video_params)
    if video.save
      render json: video.as_json(only: [:id]), status: :created #201
      return
    else
      render json: {
        errors: video.errors.messages
      }, status: :bad_request
      return
    end
  end

  def video_params
    return params.permit(:id, :title, :overview, :release_date, :total_inventory, :available_inventory)
  end
end
