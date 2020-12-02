class VideosController < ApplicationController
  def index
    videos = Video.all

    render json: videos.as_json(only: [:id, :title, :release_date, :available_inventory]),
           status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      render json: {
          errors:
              [
                  "Not Found"
              ]

      }, status: :not_found
      return
    end
    render json: video.as_json(only: [:title, :overview, :release_date, :available_inventory, :total_inventory]), status: :ok
  end

  private
  def pet_params
    params.require(:video).permit(:title, :overview, :release_date, :available_inventory, :total_inventory)
  end

end