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
  end
end
