class VideosController < ApplicationController

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      render json: {
          ok: false,
          message: 'Not found'
      }, status: :not_found

      return
    end

    render json: video.as_json(only [:title, :overview, :release_date, :total_inventory])
  end
end
