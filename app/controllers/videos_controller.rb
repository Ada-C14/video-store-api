class VideosController < ApplicationController
  def show
    video = Video.find_by(id: params[:id])
    if video.nil?
      render json: { errors: "Not Found" },
              status: :not_found
      return
    end
    render json: video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]),
            status: :ok
  end
end
