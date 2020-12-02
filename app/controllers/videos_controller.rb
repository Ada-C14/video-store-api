require 'date'

class VideosController < ApplicationController

  def index
    videos = Video.all.order(:title)
    render json: videos.as_json(only: ["id", "title", "release_date", "available_inventory"]),
                                status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      render json: {
          ok: false,
          message: "Not found"
      }, status: :not_found

      return
    end

    render json: video.as_json(only: ["available_inventory", "overview", "release_date", "title", "total_inventory"]),
                                status: :ok
  end

  def create
    video = Video.new(video_params)
    if video.save
      render json: video.as_json(only: [:id]), status: :created
    else
      render json: {errors: video.errors.messages},
             status: :bad_request
    end
    return
  end

  def checkout

  end


  private

  def video_params
    return params.permit(:id, :title, :release_date, :available_inventory, :overview, :total_inventory)
  end
end
