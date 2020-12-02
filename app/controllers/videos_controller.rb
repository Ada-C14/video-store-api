class VideosController < ApplicationController
  def index
    videos = Video.all

    render json: videos.as_json(only: [:id, :title, :release_date, :available_inventory]),
           status: :ok
  end
end