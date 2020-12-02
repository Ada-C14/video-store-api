class VideosController < ApplicationController

  def index
    videos = Video.all.as_json(only: [:available_inventory, :id, :release_date, :title])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    render json: {ok: false, errors:["Not Found"]}, status: :not_found and return if video.nil?
    render json: video.as_json(except: [:created_at, :updated_at, :id]), status: :ok
  end
end
