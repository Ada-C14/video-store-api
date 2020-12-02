class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(only: [:id,
                                      :title,
                                      :release_date,
                                      :available_inventory])
    render json: videos, status: :ok
  end

  def show

    video = Video.find_by_id(params[:id]).as_json(only: [:title,
                                                           :overview,
                                                           :release_date,
                                                           :total_inventory,
                                                           :available_inventory])
    if video.nil?
      render json: {errors: ['Not Found']}, status: :not_found
    else
      render json: video, status: :ok
    end
  end

  def create
  end
end
