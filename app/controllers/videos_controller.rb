class VideosController < ApplicationController


  def index
    videos = Video.order(:id).to_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])
    if video
      formatted_release_date = video.release_date.strftime("%B #{video.release_date.day.ordinalize} %Y")
      video = video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory])
      video["release_date"] = formatted_release_date
      render json: video, status: :ok
    else
      render json: { errors: ["Not Found"] }, status: :not_found
    end
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
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
    return params.permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end

end
