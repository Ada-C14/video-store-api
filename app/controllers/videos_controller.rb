class VideosController < ApplicationController
  def index
    videos = Video.all.order(:title)

    render json: videos.as_json(only: [:id, :title, :release_date,
                                     :available_inventory]),
           status: :ok
  end

  def zomg
    render json: { ok: 'it works' }, status: :ok

  end

  def show
    video = Video.find_by(id: params[:id])

    if video
      render json: video.as_json( only: [:title, :overview, :release_date, :total_inventory, :available_inventory]),
             status: :ok
      return
    else
      render json: {
          ok: false,
          message: 'Not found'
      }, status: :not_found
      return
    end
  end

end
