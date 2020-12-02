class VideosController < ApplicationController
  def index
    videos = Video.all.order(:title)
    render json: videos.as_json(only: ["id", "title", "release_date", "available_inventory"]), status: :ok
  end

  def create
    video = Video.new(video_params)
    if video.save
      render json: {id: video.id}, status: :created
    else
      render json: {ok: false,
                    errors: video.errors.messages},
             status: :bad_request
    end
    return
  end



  private
  def video_params
    p params
    return params.require(:video).permit(:id, :title, :release_date, :available_inventory, :overview, :total_inventory)
  end
end
