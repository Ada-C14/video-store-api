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

  def create
    video = Video.new(video_params)
    render json: video.as_json, status: :created and return if video.save
    render json: {ok: false, errors: video.errors}, status: :bad_request and return
  end

  private

  def video_params
    params.require(:video).permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end

end
