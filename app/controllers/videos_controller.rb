class VideosController < ApplicationController

  def index
    videos = Video.all.as_json(only: [:id, :title, :release_date, :available_inventory])
    render json: videos, status: :ok
  end

  # Why no overview or total_inventory from schema, per the test?
  #     t.string "title"
  #     t.string "overview"
  #     t.string "release_date"
  #     t.integer "total_inventory"
  #     t.integer "available_inventory"
  #

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      render json: {
        ok: false,
        errors: 'Not Found',
      }, status: :not_found

      return
    end

    render json: video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]),
                                status: :ok
  end

end
