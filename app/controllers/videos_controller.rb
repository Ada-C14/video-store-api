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

# def create
#
# end

private

def video_params
  params.require(:video).permit(:title, :overview, :release_date, :inventory)
end