class VideosController < ApplicationController

  def index
    videos = Video.all.as_json(only: [:id, :title, :release_date, :available_inventory ] )
    render json: videos, status: :ok
  end

  def show
  end

  def create
  end
end
