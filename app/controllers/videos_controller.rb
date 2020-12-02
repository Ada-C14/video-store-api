class VideosController < ApplicationController
  def index
    @movies = Video.all
    movies = Video.all.as_json(only: [:id, :title, :overview, :release_date, :inventory])
    render json: movies, status: :ok
  end

  def show
    movie = Video.find_by(id: params[:id])

    if movie
      render json: movie.as_json(only: [:id, :title, :overview, :release_date, :inventory])
    else
      not_found
    end
  end
end

def create
  video = Video.new(video_params)

  if video.save
    render json: video.as_json(only: [:id]), status: :ok
    return
  else
    bad_request(video)
  end
end

private

def video_params
  params.require(:video).permit(:title, :overview, :release_date, :total_inventory)
end